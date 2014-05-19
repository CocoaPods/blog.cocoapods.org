---
layout: post
title:  "CocoaPods Trunk"
author: eloy
categories: master-repo
---

After a year of architecture design and hard work, we are proud to introduce the ‘Trunk’ web-service, which will dramatically improve the user-experience of podspec publishers.

<!-- more -->

## The past and the why

Many have asked “why doesn’t CocoaPods have a simple way to publish new pods, like RubyGems and NPM etc have?”, so let’s shine some light on that.

Arguably, configuring a black-box such as Xcode and getting native code to be compiled for various platforms, deployment targets, and architectures to build and the permutations thereof is way harder than what RubyGems, NPM, and the likes have to do. Obviously this is a huge benefit of scripting languages, which (often) do not need to deal with these seemingly arcane workflows.

So, back when I started work on CocoaPods, I did not want to spend much time on a centralised web-service yet if we didn’t even know _all_ the details about our ‘core-business’ yet. Even if you can create a web-service “over a weekend”, that doesn’t mean it’s particularly helpful to the process of figuring out the hard parts, namely resolving, installing, and integrating your dependencies.

In fact, starting off with a web-service makes the whole process _harder_, because running a web-service means you now suddenly have to do maintenance on that, as the community will expect it to be up 100% of the time. And if there is **one thing** I have learned, then it’s that having this responsibility as a group of volunteers –_doing a lot of this in their spare-time and for gratis_– it is that inevitably there will be burn-out and/or the need to raise a lot of money due to possibly hard to maintain architectural decisions. (For examples of this see [rubygems TODO](TODO) and [scalenpm.org](https://scalenpm.nodejitsu.com).)

I also wanted to design the architecture so that, for instance, companies that want to use their private dependencies through CocoaPods would not have to configure and host a web-service either. Nobody wants to do more than is necessary, not in the least because it just makes for a frustrating server-admin experience.

From these reasons stems the simple solution to host these in a simple directory structure and use established SCM systems to keep these versioned and simple to distribute. This strategy to keep things simple has served us rather well. However, at a certain scale, and especially in a Open-Source environment such as our ‘master’ spec-repo, there inevitably comes a time where you need to take it to the next level…

## The problem

Our ‘master’ spec-repo boss, Ser [Keith Smiley](http://twitter.com/SmileyKeith), is a review-and-merge-monster and has been able to keep-up with all of the pull-requests that you have been sending his way for the last two years. But, as we can clearly see the rising trend of number of pods being published, at some point even Keith won’t be able to handle your scale.

Another issue we noticed is that the current workflow of creating a pull-request and automatically getting feedback from Travis in addition to manual reviews from Keith and [Paul](http://twitter.com/squarefrog) has lead to many podspec publishers being too ‘lazy’ and instead of properly testing whether or not a podspec will actually work well for a user by testing it in their own applications, they end-up updating and pushing their specs until it supposedly works. This is not only an abuse of the time our volunteers have, but it also shifts the responsibility to ensure proper working podspecs away from the publisher.

Other people in the community would like to create web-services around CocoaPods and for this they need some form of API and a format _other_ than Ruby, to be able to interpret the podspecs and provide any meaningful service around them.

Finally, at some point, even _the most well-intended person_ will slip up. A good example of this is when an unauthorised person pushed a podspec for an non-existing AFNetworking version. Obviously, the only person that should be allowed to do so is Mattt and possibly other (maintainers) that Mattt gives his blessing to do so.

The solution? An automated web-service and a database of registered 'owners' with an ACL layer that only allows designated people to release new versions.

## ‘Trunk’, our solution

![Cocoa pods on a trunk](http://upload.wikimedia.org/wikipedia/commons/e/e0/Cocoa_Pods.JPG)

_Cocoa pods in varying levels of ripeness growing on the trunk of a tree._ – [Wikipedia](http://en.wikipedia.org/wiki/Cocoa_production_in_Ivory_Coast)

Today we are launching our web-service to remedy the aforementioned problems. The introduction of the ‘Trunk’ web-service means that publishers can now publish pods directly from the command-line, _without_ the need to create a pull-request.

The first person to publish a pod automatically gets designated as the ‘owner’ of that pod name in the scope of the ‘master’ spec-repo. The ‘owner’ can then add other ‘owners’ as they see fit. Only ‘owners’ are allowed to publish subsequent versions of said pod. For more information on this and interacting with ‘Trunk’ in general, see [this guide](http://guides.cocoapods.org/making/getting-setup-with-trunk).

Note that we are still hosting the canonical database of available pods and their specifications in [the same git repo on GitHub](https://github.com/CocoaPods/Specs). This means that if something were to affect the uptime/stability of this database, our users can rely on GitHub’s professional and 24/7 support. Thus, if ‘Trunk’ were to go down, for whatever reason, our normal users are not affected and only ‘owners’ will be unable to publish new pods during that time-frame. All in all, this means better stability for _you_, our users, and less stress on _us_, the volunteers.

With regards to ensuring that a podspec works properly, _you_, the ‘owner’, and _only_ you are responsible for a podspec workig properly. We only validate your podspec on our end for the bare-minimum metadata that we need to be able to register your podspec. We will **no** longer validate your podspec for you on Travis. And we will **not** accept updates to published podspecs without a rigurous review process. Thus, it is _highly_ recommended that you test your podspec in your own real applications and/or demo applications _before_ you publish a podspec.

Finally, the ‘Trunk’ web-service will no longer store the podspecs in the Ruby format. Instead these will be stored as JSON and thus will directly be usable by people wanting to create other web-services around the CocoaPods ecosystem.

## Transition

While we transition to the ‘Trunk’ web-service, we will have a grace-period during which all the currently known pods can be claimed by their respective ‘owners’. Please read Keith’s [blog post on this topic](http://blog.cocoapods.org/Claim-Your-Pods/).

## Frequently Asked Questions

### Will I still be able to make modifications to a published podspec?

No. At least not in an automated fashion. You are allowed to create a pull-request against the ‘master’ spec-repo, but we will not necessarily accept it and we do **not** offer any guarantees on turn-around time.

### How can I distinguish the format of a podspec.

Podspecs using the Ruby DSL will use the `.podspec` extension, JSON based
podspecs will use `.podspec.json`.

### Will the specs in the Ruby format be deprecated?

No, they are here to stay and are the preferred method if you need to be able to perform automatic generation, such as collecting a list of all the source files from disk. The `pod trunk push` command will take care of converting the podspec to JSON. This means that you do _not_ have to change any existing podspecs.

### Will private repos need to adopt the JSON format?

No. Moreover, the `pod push` command will keep the old behaviour, except that we are moving this into `pod repo push` to emphasise the distinction.
Just keep in mind that if two files are available CocoaPods will prefer the JSON format.

### Can I access the specs via http?

Yes, you can use the following endpoints of the GitHub API. At a later point we will introduce a public API on ‘Trunk’ that you can use to standardise this, although it should be noted that if you do not need more than what the GitHub API already offers, it’s best to just use that, as GitHub will be able to offer better uptimes than we can.

To the get the list of the available Pods:

```
https://api.github.com/repos/CocoaPods/Specs/contents/Specs
```

To the get the available versions of a Pod:

```
https://api.github.com/repos/CocoaPods/Specs/contents/Specs/ObjectiveSugar
```

To fetch the podspec of a version of a Pod:

```
https://api.github.com/repos/CocoaPods/Specs/contents/Specs/ObjectiveSugar/0.9/ObjectiveSugar.podspec.json
```
