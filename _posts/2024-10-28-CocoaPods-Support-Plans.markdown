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

If CocoaPods' only audience were native Cocoa developers, CocoaPods' usage should be on the decline, however, that is not the case. The popularity of React Native and Flutter have ensured that [most metrics of usage/traffic](https://www.ruby-toolbox.com/projects/cocoapods) have been steadily rising over time.

This puts CocoaPods in a strange place, a lot of the maintainers don't use it, Apple have been maintaining a replacement for 9 years and the new users of the project barely even know that CocoaPods exists or what it does.

So, we concluded we need to figure out what is going on with the project and how we have been treating it as maintainers over the last few years.

### How CocoaPods Is Maintained

Strictly speaking, __we don't plan on changing how we're maintaining CocoaPods__. We're just going to start being clear how CocoaPods has been maintained:

- We will make sure to handle systemic security issues to trunk
- We will aim to make at least 2 releases a year to keep up-to-date with Xcode updates
- We will aim to look at support requests for trunk every 6 months
- We will keep the website infrastructure from not falling over completely

What we will not be doing:

- We don't actively follow GitHub issues as a support avenue for individuals
- We aren't planning on active CocoaPods development in terms of new features
- We aren't going to make guarantees about handling Pull Requests from people adding new features, or application-level bugs

### New contributors

This is where people would normally say _"If we had more volunteers or money etc"_ but we're not sure that this would help, the skills of maintaining build tooling in Ruby have grown increasingly less relevant over the years to the point that the overlap between "knows how to handle an Xcode project" and "knows what's going on in a complex ruby project" is pretty slim.

We're open to the idea that multiple people who are well motivated to do the necessary volunteer work may be out there, but the search, training and mentoring is also a big ask for existing folks who have little enough time for the project.

### Long term plans

#### Read-only Specs

We are discussing that on a very long, multi-year, basis we can drastically simplify the security of CocoaPods trunk by converting the Specs Repo to be read-only. Infrastructure like the Specs repo and the CDN would still operate as long as GitHub and jsDelivr continue to exist, which is pretty likely to be a very long time. **This will keep all existing builds working**.

We'd do this by offering a date when Trunk (our CocoaPods Specs repo authentication server) will be disabled, as trunk would be the main target in a supply-chain attack, this would nix all the key issues there. I think we'd be open to this changing if there is a popular alternative client for the Specs Repo was maintained and used by a reasonable number of the community.

#### I use CocoaPods as a Hidden Abstraction in My Project

Ouch, yeah, sorry. Open source falls apart from apathy and maintainer life-changes and there hasn't been incentives for new folks to get involved as volunteers for years. If you're commercially exposed here, then we're open to chatting - I think no-one on the current team is interested in working on this full time but that doesn't mean we can't find ways to have others who consider this a part of their job role taking over part of what keeps CocoaPods ticking. You can mail all of us at info@cocoapods.org or me personally at cocoapods@orta.io if you prefer.

