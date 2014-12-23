---
layout: post
title:  "CocoaPods 0.36 - Framework and Swift Support"
author: marius
categories: cocoapods releases
---

TL;DR: _CocoaPods 0.36_ has been released, with the long-awaited support for Frameworks and Swift.

This initially supports dynamic framework and by that it also brings enhanced support for dependencies using Apple's new programming language Swift. This has been one of the largest singular projects for CocoaPods, affecting almost all of CocoaPods' subsystems like Xcodeproj.

<!-- more -->


## And there were Swift & Dynamic Frameworks on iOS

Dynamic frameworks have always been available on OS X. That's different for iOS.
Apple's mobile platform introduced third-party dynamic framework support in iOS 8.
So the least common denominator was found before with using static libraries, which are supported on both platforms.

To the same time when Dynamic Frameworks were introduced, Apple also introduced Swift.
If you have third-party dependencies in Swift, you have only two choices:
Either throw them in your project and compile one fat binary, which is no practical solution as this increases build times by the lack of incremental compilation and makes it hard to generically manage very different dependencies, which could require different build settings etc. Or you can facilitate frameworks.
Static libraries are not an option anymore.

Why is that the case? Because Swift is still very open in design and subject to heavy changes. Unlike Objective-C, Apple doesn't ship the Swift standard runtime libraries with iOS.
This decouples the language version from the platform version.
When you build an app with Swift, you're responsible yourself to ship them.
The toolchain provides at this place `swift-stdlib-tool`, which [covers the common use cases](http://samdmarshall.com/blog/swift_and_objc.html).
As those libraries can't be statically linked multiple times, and not at all in different versions.
Furthermore it is desirable to embed them only once and not embedded multiple times, because of constraints to memory size and network speed, which are relevant for distribution.

With this release, we initially allow to use both in combination with CocoaPods.
Your project will automatically migrated or integrated, if you depend on a pod which includes Swift source code.
Furthermore you can use it, if your deployment target on iOS is greater then 8.0 or you're targeting the OS X platform, by specifying `use_frameworks!` in your Podfile.
This is an all or nothing approach per integrated target, because as we will later see, we can't ensure to properly build frameworks, whose transitive dependencies are static libraries.
So this release goes along with probably one of the most drastic change set on the whole project, which makes no stop on CocoaPods itself, but also required similar changes to Xcodeproj as well.


## Dynamic Frameworks vs. Static Libraries

![Xcode Template/Product Icons]()

So what's the difference between those both product types?

Dynamic Frameworks are bundles, which basically means that they are directories, which have the file suffix `.framework` and Finder treats them mostly like regular files. If you tap into a framework, you will see a common directory structure:

![Screenshot of BananaKit]()

They bundle some further data besides a binary, which is in that case dynamically linkable and holds different slices for each architecture.
But that's only part, which static libraries covered so far. Belong the further data, there are the following:

* **The Public Headers** - These are stripped for application targets, as they are only important to distribute the framework as code for compilation. The public headers also include the generated headers for public Swift symbols, e.g. `Alamofire-Swift.h`.
* **A Code Signature For The Whole Contents** - This has to be (re-)calculated on embedding a framework into an application target, as the headers are stripped before.
* **Its Resources** - The resources used e.g. Images for UI components.
*  **Hosted Dynamic Frameworks and Libraries** - e.g. the Swift runtime library. But since Xcode 6's release dynamic frameworks don't include anymore the Swift runtime they were compiled with.
This would lead to duplication if multiple frameworks are used.
[We have to care about]() ensuring  the Swift runtime libraries are embedded only once into the application project.
* **The Clang Module Map** - This is mostly an internal toolchain artifact, which carries declarations about header visibility and module link-ability.
* **An Info.plist** - This specifies author, version and copyright information.


### Caveats

One caveat about bundling resources is, that until now we had to embed all resources into the application bundle.
The resources were referenced programmatically by `[NSBundle mainBundle]`.
Pod authors were able to use `mainBundle` referencing to include resources the Pod brought into the app bundle.
But with frameworks, you have to make sure that you reference them more specifically by getting a reference to your framework's bundle e.g.

```objective-c
[NSBundle bundleForClass:<#ClassFromPodspec#>]
```

```swift
NSBundle(forClass: <#ClassFromPodspec#>)
```

This will then work for both frameworks and static libraries.
There are only very rare cases, where you want to reference the main bundle directly or indirectly, e.g. by using `[UIImage imageNamed:]`.

The advantage to the improved resource handling is that resources won't conflict when they have the same names.
They are namespaced by the framework bundle.
Furthermore we don't have to apply the build rules ourself to the resources as e.g. asset catalogs and storyboards need to be compiled.
This should decrease build times for project using Pods that include many resources.


### More about Frameworks

If you want learn more about Frameworks, take a look into the [Framework Programming Guide](https://developer.apple.com/library/mac/documentation/MacOSX/Conceptual/BPFrameworks/Frameworks.html#//apple_ref/doc/uid/10000183-SW1).
Even though this was not written specifically for the new Cocoa Touch Frameworks, how Apple calls them in their Xcode target template, those are mostly the same to the classic OS X frameworks, so this document is still a helpful introduction.


## Updating

To install the last release of CocoaPods you can run:

```bash
$ [sudo] gem install cocoapods
```

Until version 1.0 we strongly encourage you to keep CocoaPods up-to-date.

For all the details, don’t miss the
[Changelog](https://github.com/CocoaPods/CocoaPods/blob/master/CHANGELOG.md)!
