---
layout: post
title:  "CocoaPods 0.29"
author: fabio
categories: cocoapods releases
---

TL;DR: _CocoaPods 0.29 introduces the pod try subcommand and fixed header
warnings._

Every now and then we hear about tiny yet huge feature requests for CocoaPods.
Pod try is one of these. Suggested by [Laurent Sansonetti], pod try quickly
gained a spot among the feature of CocoaPods which I love the most. But…
What is it?

[Laurent Sansonetti]: https://twitter.com/lrz

<!-- more -->


## Pod Try

Pod try is a new subcommand which allows to quickly test the demo project of a
Pod. It can be used to test the quality of the implementation of a library,
very useful for user interface elements, or to pick up how to use it from the
demo project.

{% breaking_image /assets/blog_img/CocoaPods-0.29/pod-try.gif %}

In other words the command automates the following steps:

1. Checkout the source of the Pod in a temporary directory.
- Search for any project looking like a demo project using some simple heuristics.
- Install any CocoaPods dependencies if needed by the located project.
- Open the workspace/project in Xcode.

To check it out just update to the last release of CocoaPods and run:

```
$ pod try LMAlertView
```

## Header warnings

Another great feature in this release is the ability to silence also the 
warnings of the headers of the Pods.

This feature was contributed by the new core team member [swizzlr]

[swizzlr]: https://github.com/swizzlr

## Bug fixes

This release fixes the issues of the `pod lib lint` subcommand and includes a
stream of other fixes from the tireless [Joshua Kalpin].

[Joshua Kalpin]: https://github.com/Kapin

## Updating

To install the last release of CocoaPods you can run:

```
$ [sudo] gem install cocoapods
```

Until version 1.0 we strongly encourage you to keep CocoaPods up to date.

For all the details, don't miss the
[Changelog](https://github.com/CocoaPods/CocoaPods/blob/master/CHANGELOG.md).

