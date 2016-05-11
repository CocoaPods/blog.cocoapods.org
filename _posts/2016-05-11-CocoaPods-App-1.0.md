---
layout: post
title:  "CocoaPods App 1.0"
author: orta
categories: cocoapods app release
---

After about a [year of work](https://github.com/CocoaPods/CocoaPods-app/graphs/contributors), with the release of [CocoaPods 1.0](http://blog.cocoapods.org/CocoaPods-1.0/), the corresponding Mac App is also ready for public usage. 

This is no big reveal, we've been advertising it's existence on our websites for a while. I've already talked a little bit about the tech behind the [Mac App](https://blog.cocoapods.org/CocoaPods-App), so this post is the one that makes you say our "team we should use this instead of the gem".

So let me put [my best hat on](/assets/blog_img/app-1.0/hat-on.jpg), and try to pursuade you that using the CocoaPods Mac App is a _great idea._

<!-- more -->

## What problem does this solve?

CocoaPods exists within the ruby ecosystem. The majority of Cocoa developers don't have much overlap with writing ruby programs. Installing and maintaining multiple versions of command-line tools like CocoaPods is something that people have to learn in order to use CocoaPods effectively. 

This creates a problem which [Bundler solves](https://guides.cocoapods.org/using/a-gemfile.html) really well, but now you're starting to really dive into the ruby ecosystem and the pre-requisite knowledge to contribute raises again. While I'm on my soap-box, if you're using the [CocoaPods](https://rubygems.org/gems/cocoapods) and [Fastlane](https://rubygems.org/gems/fastlane) gems in an app, you probably should be using [Bundler](http://bundler.io).

So the CocoaPods app hosts everything. Literally, it has it's own self-contained copies of `bzr`, `curl`, `git`, `mercurial`, `ncurses`, `openssl`, `pkg-config`, `ruby`, `scons`, `serf`, `subversion`, `yaml` and `zlib`. This allows the CocoaPods team to ensure consistent behavior across all user setups.

This concept is not new for Cocoa developers, as Xcode has been embedding its own dependencies inside it's `.app` since it moved to the Mac App Store. The advantage from a user's perspective is that it works, and you can install your own crazy version of `git`, or `curl` or `ruby`, and it just works.

## What does it do well?

Glad you asked, 'cause it does two things really well:

* Running `pod install` or `pod update`
* Editing a Podfile

That was basically the spec for the app from day 1. Once [@alloy](https://twitter.com/alloy/) had proved that `pod install/update` was working, [@nate_west](https://twitter.com/nate_west) and I took over and started working on the latter.

### Podfile Editing

Some of these features are mundane, _"hey, wow, syntax highlighting&lt;/sarcasm>"_ but others are really fascinating deep levels of context-specific integration that you'd expect from an IDE.

We've started out with syntax highlighting, and then added useful examples of auto-completion results that show how to use the Podfile DSL.

{% breaking_image /assets/blog_img/app-1.0/useful-autocomplete.png, /assets/blog_img/app-1.0/useful-autocomplete.png %}

The app will auto-complete your pods, including private pods. This feels magical when you don't expect it. We've been having discussions about ways to introduce more of the internal CocoaPods knowledge into the [auto-complete like this](https://github.com/CocoaPods/CocoaPods-app/issues/311) - you're welcome to help out.

{% breaking_image /assets/blog_img/app-1.0/autocomplete-pods.png, /assets/blog_img/app-1.0/autocomplete-pods.png  %}

The app will generate an overview of what your integration will look like without needing to be installed, so you can understand what CocoaPods _will_ do before it has done it.

{% breaking_image /assets/blog_img/app-1.0/integration-overview.png, /assets/blog_img/app-1.0/integration-overview.png  %}

The app provides a UI for updating your Specs repos, you can find out a little bit more about why this is needed in our [Master spec-repo rate limiting post‑mortem](/Master-Spec-Repo-Rate-Limiting-Post-Mortem).

{% breaking_image /assets/blog_img/app-1.0/update-specs.png, /assets/blog_img/app-1.0/update-specs.png %}

It also has the ability to start a new CocoaPods project, or to even remove CocoaPods from a project entirely. I don't want to give away all of the app's secrets though, so you should give it a test run.

<center>
  <a href = "https://cocoapods.org/app" style="margin-top: 100px; background: #4A90E2; border-radius: 12px; color: white; padding: 20px;">Check the site</a>
<a href = "https://github.com/CocoaPods/CocoaPods-app/releases/download/1.0.0/CocoaPods.app-1.0.0.tar.bz2/" style="margin-top: 100px; background: #4A90E2; border-radius: 12px; color: white; padding: 20px;">Download App</a>
</center>

### Thanks

It wouldn't be an announcement without a thanks to [people involved](https://github.com/CocoaPods/CocoaPods-app/graphs/contributors), it's a fascinating project to work on due to the interesting [layers of tech involved](/CocoaPods-App/), but one of the coolest things about building this app, is that it provides a project for people who are Cocoa developers to contribute back without learning a new language. So we've been recieving a lot of PRs to the app, and it is always a joy to work with more.

I want to specifically call out [Nate West](https://github.com/nwest), who has been working with me on the app through-out 2016. His contributions to this project have been significant, and through this he's contributed to more of our core projects. 

We have [a lot of ideas](https://github.com/cocoapods/cocoapods-app/issues) for where the app can go, and some [low-hanging fruit](https://github.com/cocoapods/cocoapods-app/issues?q=is%3Aissue+is%3Aopen+label%3A%22easy+first+step%22) for contributors. [Why not help us with take it somewhere new?](https://github.com/CocoaPods/CocoaPods-app#building-for-development)