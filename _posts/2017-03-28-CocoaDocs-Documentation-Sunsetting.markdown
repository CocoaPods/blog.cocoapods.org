---
layout: post
title:  "CocoaDocs documentation sun-setting"
author: orta
categories: cocoadocs documentation cocoapods.org
---

TL;DR: _CocoaDocs_ will stop generating DocSets for new libraries and versions using CocoaPods towards the end of May.

I started [CocoaDocs][cd] [back in][cd_tweet] February 2013, and have been running and maintaining it for the last 4 years. CocoaDocs started as a way to generate documentation for Objective-C projects via [Appledoc][appledoc]. When Swift came out, [Jazzy][jazzy] support was added to the app. Since then, CocoaDocs has grown organically over the years into a tool to [generate useful metadata][cd_post] for any CocoaPods library used in the CocoaPods.org website.

I intend to remove the support for generating the HTML pages, and the DocSet generation for new libraries uploaded to trunk as by the end of May.

<!-- more -->

I would like to reduce the complexity in CocoaDocs. It's rare for a week to go by without an issue or two in the [CocoaDocs repo][cd_repo] about a specific library, or tooling setup that requires human intervention on the server. These issues arise from either Xcode itself, or tools which rely on Xcode infrastructure to do their work. Making it hard to fix wholesale.

By removing these parts of the system, I can keep maintaining the aspects of CocoaDocs that are used the most: creating metrics (for search) and README/CHANGELOG summaries for CocoaPods.org.

I don't think it's fair to hoist the maintenance of CocoaDocs on other contributors to CocoaPods. It's a complex tool that requires a lot of unique knowledge in unrelated areas.

So, I think this is a great time for someone else to consider re-thinking the original premise of CocoaDocs and create something that works with Swift Package Manager as well as CocoaPods. I hear server-side Swift is becoming a thing, so maybe you can create a new service for the community with it?

Due to the lengthy time required in a Cocoa project compilation, you probably would end up with a similar architecture as CocoaDocs. This means making a simple REST server, which provides a queue-like infrastructure to parse documentation which uploads the results to a static asset host. In this case CocoaDocs uses S3, and costs somewhere in the range of $20 a month.

If you decide to give it a shot, let me know once you have a prototype and I'll happily provide as many resources as I can. We can set up web-hooks from CocoaPods trunk too.

[cd]: http://cocoadocs.org/
[cd_tweet]: https://twitter.com/orta/status/318481722129907712
[appledoc]: https://github.com/tomaz/appledoc
[cd_post]: http://blog.cocoapods.org/CocoaPods.org-Take-Two/
[jazzy]: https://github.com/realm/jazzy
[cd_repo]: https://github.com/CocoaPods/cocoadocs.org/
