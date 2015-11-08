---
layout: post
title:  "Introducing: Creme de la Pods"
author: orta
categories: twitter cocoapodsfeed cocoapods
---

TL;DR: _You could always find out what was new with [@CocoaPodsFeed](https://twitter.com/cocoapodsfeed) and [feeds.cocoapods.org](https://feeds.cocoapods.org). Now you can see new CocoaPods that have a [QI](https://guides.cocoapods.org/making/quality-indexes.html) score of over 70 on [@CremeDeLaPods](https://twitter.com/cremedelapods)._

Keeping on top of the community's work is a challenge, with ~13,500 CocoaPods available and roughly 20 new pods every day. We work on CocoaPods to encourage  [contributions to OSS](https://github.com/CocoaPods/CocoaPods#project-goals). A by-product of this is that if you follow the whole stream of new CocoaPods, it can get hard to distinguish between "my first library" and "an awesome paradigm _swift_."

I have taken a stab at solving this problem, by trying to select the best pods by their [Quality Index](https://guides.cocoapods.org/making/quality-indexes.html). The first time we run documentation parsing for a Pod, if that Pod's QI is over 70 then [CocoaDocs] (https://github.com/CocoaPods/cocoadocs-api/commit/3dd3ee32f253d485576fb49fa272945cd5d5462b) will send out a tweet on the [@CremeDeLaPods](https://twitter.com/cremedelapods) twitter feed, with the exact same formatting as [@CocoaPodsFeed](https://twitter.com/CocoaPodsFeed).

<a class="twitter-follow-button" href="https://twitter.com/CremeDeLaPods">Follow @CremeDeLaPods</a>

<!-- more -->

If you've already seen tweets from [@CocoaPodsFeed](https://twitter.com/CocoaPodsFeed) before, there should be no surprises on the look of those tweets on CremeDeLaPods:

<center>
  <blockquote class="twitter-tweet" lang="en" data-cards="hidden"><p lang="en" dir="ltr">[Venice] CSP for Swift 2 (Linux ready) <a href="https://t.co/DdPyqojBjI">https://t.co/DdPyqojBjI</a></p>&mdash; Creme De La Pods (@CremeDeLaPods) <a href="https://twitter.com/CremeDeLaPods/status/663133105809698821">November 7, 2015</a></blockquote>

  <blockquote class="twitter-tweet" lang="en" data-cards="hidden"><p lang="fr" dir="ltr">[ControllerContainer by <a href="https://twitter.com/3lvis">@3lvis</a>] View Controller Containment for humans <a href="https://t.co/3WgHkIrUUa">https://t.co/3WgHkIrUUa</a></p>&mdash; Creme De La Pods (@CremeDeLaPods) <a href="https://twitter.com/CremeDeLaPods/status/662624562778144770">November 6, 2015</a></blockquote>
  </center>

Every Pod also comes with an overview image too, making it easy to see some of the salient properties.

  <center>
  <blockquote class="twitter-tweet" lang="en"><p lang="en" dir="ltr">[Money by <a href="https://twitter.com/danthorpe">@danthorpe</a>] Swift types for working with Money. <a href="https://t.co/jCdJlrZV9Z">https://t.co/jCdJlrZV9Z</a></p>&mdash; Creme De La Pods (@CremeDeLaPods) <a href="https://twitter.com/CremeDeLaPods/status/662573883728490496">November 6, 2015</a></blockquote> <script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

  <a class="twitter-follow-button" href="https://twitter.com/CremeDeLaPods" data-size="large">Follow @CremeDeLaPods</a>
</center>

It's easy to forget that a lot of people are just getting started, and learning how to ship a Podspec is an important step towards community participation. We want people to feel welcome at all stages of their careers, so we'll always be showing and hosting the unfiltered feed.

We've talked about, in the future, supporting tweeting when any pod's version moves to  getting to a score of 70+. This should be a bit more accommodating for improvements after seeing an initial score, rather than  set up at the start.

<img src="https://camo.githubusercontent.com/cf5c440e71f6731b22d5d014d183709906bab61a/687474703a2f2f7777772e746865706c757370617065722e636f6d2f77702d636f6e74656e742f75706c6f6164732f323031352f30342f332e676966">
