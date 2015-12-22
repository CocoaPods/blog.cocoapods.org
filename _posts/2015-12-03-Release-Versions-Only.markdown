---
layout: post
title:  "Release Versions Only"
author: florian
categories: cocoapods.org search versioning
---

The main CocoaPods website, [cocoapods.org](https://cocoapods.org), lets you search for all versions of a pod.
That includes prerelease versions.
As a result, when searching for a pod with a prerelease version, the latest prerelease version is shown in the result list.

This sounds good in principle, but the behaviour is at odds with how the `pod` command operates.
The default there is to use the latest _released_ pod version.
As a result of this – as we noticed via our stats system – usage of prerelease versions is minimal, and showing the latest prerelease version on [cocoapods.org](https://cocoapods.org) violates expectations as to what `pod install` will actually install.

Therefore, we will be switching to the `pod` command default also on [cocoapods.org](https://cocoapods.org), meaning in the results, we will show only released versions.
We've prepared all systems for the switch and will flip it on December 27th 2015 during the holiday lull.

Happy Holidays, pod friends!
