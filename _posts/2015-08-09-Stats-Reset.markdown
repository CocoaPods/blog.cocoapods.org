---
layout: post
title:  "CocoaPods Stats Reseting"
author: orta
categories: cocoapods website
---

TL;DR: _CocoaPods Stats is ready to move from it's current staging environment_, and we will be resetting all stats next weekend.

<!-- more -->

When I set up CocoaPods Stats, the API + analytics database with the help from [Segment](http://segment.com). I created it within a staging environment in our analytics database. I gave it two months to gather enough data in order for us to be sure that the at-the-time evolving table data structure works. 

Looks like it is working. In that time, people using only the latest releases of CocoaPods, have used CocoaPods to download [AFNetworking](https://cocoapods.org/pods/AFNetworking) almost 100,000+ times, on 6500+ individual projects.

So, next week I will migrate the stats server to production and everything will be back to zero downloads / installs again.
