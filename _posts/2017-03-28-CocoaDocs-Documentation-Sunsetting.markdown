---
layout: post
title:  "CocoaDocs documentation sun-setting"
author: orta
categories: cocoadocs documentation cocoapods.org
---

TL;DR: _CocoaDocs_ will stop generating DocSets for libraries using CocoaPods towards the end of May.

I started [CocoaDocs][cd] [back in][cd_tweet] February 2013, and have been running and maintaining it for the last 4 years. CocoaDocs started as a way to generate documentation for Objective-C projects via [Appledoc][appledoc]. When Swift came out, [Jazzy][jazzy] support was added to the app. Since then, CocoaDocs has grown organically over the years into a tool to [generate useful metadata][cd_post] for any CocoaPods library used in the CocoaPods.org website.

I intend to remove the support for just generating the HTML pages, and the DocSet generation for new libraries as by the end of May.

<!-- more -->

I would like to reduce the complexity in CocoaDocs. It's rare for a week to go by without an issue or two in the [CocoaDocs repo][cd_repo] about a specific library, or tooling setup that requires human intervention on the server. These issues arise from either Xcode itself, or tools which rely on Xcode infrastructure to do their work. Making it hard to fix wholesale.

By removing these parts of the system, I can keep maintaining the aspects of CocoaDocs that provide the most usage: creating metrics (for search) and README/CHANGELOG summaries for CocoaPods.org.

It's not reasonable to hoist the maintenance of CocoaDocs to other contributors to CocoaPods, it's a complex tool that requires a lot of unique knowledge.

So, I think this is a great time for someone else to consider re-thinking the original premise of CocoaDocs, and create something that works with Swift Package Manager as well as CocoaPods. I hear server-side Swift is becoming a thing, so maybe you can create a new service for the community with it?

[cd]: http://cocoadocs.org/
[cd_tweet]: https://twitter.com/orta/status/318481722129907712
[appledoc]: https://github.com/tomaz/appledoc
[cd_post]: http://blog.cocoapods.org/CocoaPods.org-Take-Two/
[jazzy]: https://github.com/realm/jazzy
[cd_repo]: https://github.com/CocoaPods/cocoadocs.org/
