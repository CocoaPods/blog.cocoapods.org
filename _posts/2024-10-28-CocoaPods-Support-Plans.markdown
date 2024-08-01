---
layout: post
title:  "CocoaPods Support & Maintenance Plans"
author: orta
categories: cocoapods 
---

**TLDR: We're still keeping it ticking, but we're being more up-front that CocoaPods is in maintenance mode.**

CocoaPods is about 13 years old now, and the landscape of iOS development has changed a lot in that time. I remember the fragmented islets of small shared libraries (like: ASIHTTPRequest, Nimbus, SBJson, SSToolkit, iCarousel) with tricky upgrade instructions and complicated build setups. CocoaPods simplified that process enough that it turned into the de-facto way to share code in the iOS and Mac community.

In [2015](https://x.com/orta/status/672436829250052102), Apple announce that the CocoaPods project [had been Sherlocked](https://www.npr.org/2024/06/17/g-s1-4912/apple-app-store-obsolete-sherlocked-tapeacall-watson-copy) because they were going to be creating their own package manager: Swift Package Manager. This move effectively took all the wind out of the sails of CocoaPods, slowing active development of the project as competing with Apple on their own turf is rarely a battle worth your volunteer hours.

Since Swift Package Managers announcement last 9 years, members of the core team have individually had reasons for continual maintenance: a sense of duty, being employed to work on libraries or apps which use CocoaPods, working on build infra for large projects where CocoaPods is a key part of the build process or just a love of the community.

However, with time - these links become more tenuous too, jobs change, people move to new ecosystems and we've slowly been moving CocoaPods to an place where work only happens when something external causes it. That could be security issues like I've reported the last few years on the blog, or Xcode breaking changes which require us to tweak some settings and make a new build.

If CocoaPods' only audience were native developers, CocoaPods' usage should be on the decline, however, that is not the case. The popularity of React Native and Flutter have ensured that [most metrics of usage/traffic](https://www.ruby-toolbox.com/projects/cocoapods) have been steadily rising over time. This 