---
layout: post
title:  "CocoaPods.org v2.5"
author: orta
categories: cocoapods.org releases website 
---

After our awesome State of the Union, I pushed the new version of the CocoaPods website to Heroku. It comes with a bunch of new features, some new pages and a few interface tweaks, let's go through what's new.

<!-- more -->

{% breaking_image /assets/blog_img/cocoapods-org-2-5/cocoapods25.jpg, https://cocoapods.org/pods/Cartography,  width="1024", no-bottom-margin %}

## Quality Index

We built a series of quality approximations that sit on top of the deep metrics that exist within CocoaPods. These are a series of rules that we apply against a pod every time a new pod version is pushed. They range from GitHub popularty, to download size and a rough version of how well tested it is.

There are currently 17 metrics ([see the code](https://github.com/CocoaPods/cocoadocs-api/blob/master/quality_modifiers.rb)) that we use to estimate the quality of every library. The algorithm starts with a number then adds and subtracts to it based on the metric. They are both positive and negative metrics, for example releasing a Pod under the GPL license will detract some points while having a lot of GitHub stars will add to the number. In order to make this process transparent [Hugo Tunis](https://twitter.com/K0nserv) and [Esteban Torres](https://twitter.com/esttorhe) created a new web page showing all of the rules that apply to your pod.

{% breaking_image /assets/blog_img/cocoapods-org-2-5/pods.png %}

## Pod Ordering

We've transitioned the default pod search ordering from GitHub stars to the overall Quality Index. In part this is because the CocoaPods ecosystem is bigger than GitHub, and  while popularity is pretty well correlated with GitHub stars it often can just be an indicator that people liked the idea. Using the Quality Index we can take that into account, but also that it is well documented, has tests and many other aspects.

## Pod Page improvements

We streamlined the main section of the Pod page. We did this by moving a lot of the interesting metrics that we have to the sidebar, and to re-think the hierarchy of the data on the side. We're actively cleaning up READMEs when displaying in Pod pages for things like CI/Coverage badges and CocoaPods installation notes to keep it focused on just the pods documentation. Installation details are available in the sidebar.

## Owner pages

Terminology is important here, an owner is someone who has access to push a Pod to trunk. The library author is someone who created the library. Nearly all of the time they are the same, but there are examples ( [ARAnalytics](https://cocoapods.org/pods/ARAnalytics) ) where they differ. We have created owner pages for the people with access to push a pod, right now we don't have pretty URLs for your owners but you can jump to any Pods you own and you'll see a link to your page. We show all the Pods an owner has access to, and a little bit of information around the pod.

I'm super happy with the changes to the website, I think it makes it easier than ever to discover higher quality libraries that might not have hit the big-time yet. Everyone can let out a sigh of relief now, we can figure out the best [Swift JSON ORM](https://cocoapods.org/?q=lang%3Aswift%20json).
