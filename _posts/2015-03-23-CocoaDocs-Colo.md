---
layout: post
title:  "CocoaDocs Co-located"
author: orta
categories: cocoadocs.org releases website
---

TL;DR: [CocoaDocs.org][1] just got Jazzy support, became more stable, and is now sending stats to our status page.

<!-- more -->

## History.

CocoaDocs is a server that generates CocoaPods documentation. It started out by generating Apple-compliant DocSets via [appledoc][2] on a hosted Mac and then sends the results to Amazon's S3 where they are served statically.

## Maturation Process

Appledoc is great, but it's not going to be supporting Swift anytime soon. It's a pre-ARC project that isn't compilable with modern Xcodes. CocoaPods has been supporting Swift Pods since xmas 2014, we wanted to be able to provide hosted documentation for these pods too. Sam Giddins took the initiative here and added [early support][3] for Swift Pods via [Jazzy][4]. You can see a few Pods here: [Observable](http://cocoadocs.org/docsets/Observable-Swift/0.4.2/) , [Moya](http://cocoadocs.org/docsets/Moya/0.6.1/), [JSONJoy](http://cocoadocs.org/docsets/JSONJoy-Swift/0.9.1/) and [QRReader.swift](http://cocoadocs.org/docsets/QRCodeReader.swift/3.1.7/). There's no fancy design work yet, we will get to that in time.

Given Swift's immaturity, this is going to be an interesting problem, as the CocoaDocs server has no way of determining which version of Swift your library supports. For now this is solved by only supporting stable Xcode releases. In the future, it may make sense to add a range of supported Swift releases to your podspec per-release.

Towards the end of the 2014 the CocoaDocs server was starting to have some real issues, the generator would be down for days, and trying to `ssh` in would fail. It was turning out that the shared VPS we were using was falling over after a certain amount of time, likely due to running RAM. In order to get the server back up and running I had to submit a support ticket and get someone else to reboot it.

Around this time frame [Button][5] reached out to me to ask if this was a problem they could help solve. Given that until this time I had been paying for CocoaDocs myself, I had done everything I could to optimise it for my wallet. ( CocoaDocs was costing me about $450 a year. ) So we jumped at the chance to do it right. CocoaDocs is now running on [macminicolo.net][6], and it's a dream to ssh or Screen Share.app in. Thanks a lot [Button][5]!

In the [process](https://github.com/CocoaPods/cocoadocs.org/issues/320) of moving I added one more feature, we now send data to the [CocoaPods status][7] page saying how many pods have been doc'd in the last 24hrs.

[1]:	http://cocoadocs.org
[2]:	https://github.com/tomaz/appledoc
[3]:	https://github.com/CocoaPods/cocoadocs.org/pull/279
[4]:	https://github.com/realm/jazzy
[5]:	http://www.usebutton.com
[6]:	http://www.macminicolo.net
[7]:	http://status.cocoapods.org
