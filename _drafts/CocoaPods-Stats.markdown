---
layout: post
title:  "CocoaPods Stats"
author: orta
categories: cocoapods.org release stats
---

People have been asking for years about getting feedback on how many downloads their libraries have got. We've been thinking about the problem for a while, and finally ended up asking Segment if they would provide a backend for the project.

<!-- more -->

### But wait, there's more...

It wasn't just enough to offer just download counts. We spend a lot of time working around Xcode's project file intricacies, however in this context, it provides us with foundations for a really nice feature. CocoaPods Stats will be able to keep track of the unique number of installs within Apps / Watch Apps / Extensions / Unit Tests.

What this means is that developers using continuous integration only increase the downloads of the Pod, but register as 1 install. Separating total installations vs actual downloads.

{% breaking_image /assets/blog_img/stats/stack.png, https://cocoapods.org/pods/ORStackView,  width="1024", no-bottom-margin %}

### Alright, hold up

Let's go over how we check which pods get sent up for analytics, and how we do the unique installs. [CocoaPods-Stats](https://github.com/cocoapods/cocoapods-stats) is a plugin that will be bundled with CocoaPods iwthin a version or two. It [registers](https://github.com/CocoaPods/cocoapods-stats/blob/0361f29ae37e82ccf385319bba9cf31464049144/lib/cocoapods_plugin.rb#L6) as a post-install plugin and is ran on every `pod install` or `pod update`.

#### Detecting Public Pods

 We're very pessimistic about sending a pod up to our [stats server](https://github.com/cocoapods/stats.cocoapods.org) the current code will ensure that you have a CocoaPods/Specs repo set up as your master repo, then ensure that each pod is inside that repo before accepting it as a public domain pod. It looks like this:

 ```ruby
  # Does the master specs repo exist?
  master_specs_repo = File.expand_path "~/.cocoapods/repos/master"
  return unless File.directory? master_specs_repo

  # Is the master specs repo actually the CocoaPods OSS one?
  Dir.chdir master_specs_repo do
    git_remote_details = `git remote -v`
    return unless git_remote_details.include? "CocoaPods/Specs"
  end

 ...

  # Verify that the pod exists in the master specs repo
  pods = root_specs.select do |spec|
    File.directory? File.join(master_specs_repo, "Specs", spec.name)
  end
 ```

####  Data being sent

First up, we don't want to know anything about your app. So in order to know unique targets we use your project's target [UUID](https://github.com/artsy/eigen/blob/aea7af93daffb716ccee9aa50ce599dc7949c42b/Artsy.xcodeproj/project.pbxproj#L3888) as an identifier. These are a [hash](http://danwright.info/blog/2010/10/xcode-pbxproject-files-3/) of your MAC address, Xcode's process id and the time of target creation. These UUIDs never change in a project's lifetime. We double hash it just to be super safe.

``` ruby
  # Grab the project and the type of target
  uuid = target.user_target_uuids.first
  project_target = project.objects_by_uuid[uuid]

  # Send in a digested'd UUID anyway, a second layer
  # of misdirection can't hurt
  {
    :uuid => Digest::SHA256.hexdigest(uuid),
    :type => project_target.product_type,
    :pods => pods
  }
```

We then also send along the CocoaPods version that was used to generate this installation. Ideally before release we'll also be able to give statistics on how many people are using `pod try [pod]` for your library too.

## FAQ

#### Can I opt out as a CocoaPods user?

Sure. You can set an [environment variable](http://apple.stackexchange.com/questions/106778/how-do-i-set-environment-variables-on-os-x) `DISABLE_COCOAPODS_STATS` to true in your shell, and stats will not be sent from your machine.

#### Does this affect every pod?

Yeah, every pod will get download stats.

#### Will it be live stats?

No, they get generated once per day.

#### What is the rollout strategy?

We plan on making this initially a separate CocoaPods plugin that you can optionally install via `[sudo] gem install cocoapods-stats` which will send the data. In a release or two we will bundle this into CocoaPods, and it will be installed by default for everyone moving forwards.

#### Can I use this to find out how many people are using an older build of my pods

Not automatically, we've not figured out a strategy for doing this yet, but you can email orta@cocoapods.org for one off requests once it's up and running. Ideally once this has settled I'd like to take a look at making a stats overview page per pod, but that has some tricky technicalities.

#### How does this affect the quality indexes / sorting?

Ideally we can reduce the amount of impact GitHub stars affects your quality index, and replace some of the values with new metrics based on downloads/installations.

#### What commands does this run on?

It runs at the end of a `pod install` or a `pod update`.

#### I check in my Pods, how does this affect stats?

Checking in your Pods will mean that the download count for the pods used will rarely be affected, but the installations will be the exact same. They only register once per project, so multiple developers on the same project running pod install will not raise this number.
