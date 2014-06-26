---
layout: post
title:  "pod lib create v2"
date: 2014-06-26
author: orta
categories: feature cocoapods
---

`pod lib create` has been our way of trying to encourage standards, and to make it easy to create a new library. Before today it would leave a [lot of setup](http://code.dblock.org/reorganizing-cocoapod-folder-structure-for-unit-and-integration-testing) at the developer's discretion. The new version automates a lot of common problems away and starts you with a new library structure. Read on for details.

Or just go straight to the [Using Pod Lib Create guide](http://guides.cocoapods.org/making/using-pod-lib-create.html).

<!-- more -->

Rather than explain what it does, which the guide does a better job of, I want to show the end result:

<center>
<a href="http://guides.cocoapods.org/assets/images/pod_lib_create/xcode.png"><img src="http://guides.cocoapods.org/assets/images/pod_lib_create/xcode.png" class="image-zoom"></a>
</center>

1. You can edit your Podspec metadata, like the README and Library Podspec in Xcode.
* There is an automatically generated project with your own Prefix settings.
* Extremely easy to start writing library tests, we include stubs for Specta/Expecta and Kiwi.
* Your library is set up as a Development Pod.
* We include some useful Pods for bootstrapping your project.

This update is available today because of how Fabio built templates to allow for custom repos, and it definitely accepts [pull requests and issues](https://github.com/CocoaPods/pod-template).