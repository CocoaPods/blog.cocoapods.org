---
layout: post
title:  "On Launching </br>CocoaDocs Version 2"
author: orta
categories: cocoadocs new cocoadocs2
date: 2014-05-26
---

In March 2013 I uploaded the [initial commit](https://github.com/CocoaPods/cocoadocs.org/commit/93e9896b04f79eb09be28a9056671b1d23f3143d) for [CocoaDocs](http://cocoadocs.org). This action triggered a roller-coaster [year for me](http://orta.github.io/on/being/27/#cocoadocs). I'm super excited to announce the second iteration of CocoaDocs is now running and [parsing](http://cocoadocs.org/docsets/ReactiveCocoa/2.3.1/) [new](http://cocoadocs.org/docsets/ARAnalytics/2.7.2/) [Docsets](http://cocoadocs.org/docsets/BlocksKit/2.2.3/).

<!-- more -->

{% breaking_image /assets/blog_img/cocoadocs/headline.jpg, http://cocoadocs.org/docsets/OHHTTPStubs/3.1.2/,  width="1024", no-bottom-margin %}

## Key Features List

* Travis CI is now important
* Documentation number of shame
* Easy access to License info
* Per <a href="http://cocoadocs.org/readme">library style</a> settings
* Programming Guides
* <a href="http://kapeli.com/dash">Dash</a> specific layouts

So it came to me as a surprise that CocoaDocs narrowly beats the CocoaPods Guides in terms of web traffic. It was the original point at which I (<a href="http://orta.github.io">orta</a>) had made a major contribution to the OSS community, and whilst it's great technically, it has always bothered me that I was constrained in the design. It bothered me enough that I [started a redesign process](/redesign/) for the entire of CocoaPods. Now I am free of this burden.

With the mostly solid foundations of CocoaDocs working, I was free to sit back and debate the wider reaching implications. CocoaDocs at its core is about best practices, [adding documentation](http://nshipster.com/documentation/) is an important part of a libraries lifecycle. I believe testing is another, because of how easy it is to get started with Travis CI and the fact that it is free for open source it is in my opinion a no-brainer to include that metadata in a library.

## Getting started

{% breaking_image /assets/blog_img/cocoadocs/readme.jpg, http://cocoadocs.org/readme, width="1024", no-bottom-margin %}

I also felt that CocoaDocs was a black box for developers who didn't want to read the source code, which is basically everyone. So I've taken the liberty of creating a [CocoaDocs Developer Docs](http://cocoadocs.org/readme/). This is an area where you can preview your custom styling, and get the answers to a lot of the questions I've answer on twitter. 

## Coming up

This is not a full release of CocoaDocs 2, I'm waiting till post WWDC 2014 to know whether the world has changed yet again to start the process of running CocoaDocs on over 15k libraries. During this time period new libraries get the new style, old libraries keep the old style. There are still a few [open issues](https://github.com/CocoaPods/cocoadocs.org/issues?state=open) on CocoaDocs but there's time, but this is the 95%.

CocoaDocs could not have existed without help from [appledoc](http://gentlebytes.com/appledoc/), [Danger](/assets/blog_img/cocoadocs/danger.jpg), the [CocoaPods Dev Team](http://cocoapods.org/about) and everyone who has contributed a library.