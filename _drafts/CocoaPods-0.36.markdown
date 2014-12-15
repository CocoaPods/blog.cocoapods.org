---
layout: post
title:  "CocoaPods 0.36 - Framework and Swift Support"
author: marius
categories: cocoapods releases
---

TL;DR: _CocoaPods 0.36_ has been released, with the long-awaited support for Frameworks and Swift.

<!-- more -->

The CocoaPods 0.36 brings long-awaited functionality: it initially supports dynamic framework and by that it also brings enhanced support for Apple's new programming language Swift.


## And there were Swift & Dynamic Frameworks on iOS

Dynamic frameworks have always been available on OS X. That's different for iOS. Apple's mobile platform does support dynamic frameworks initially with iOS 8.0. So the least common denominator was found before with using static libraries, which are supported on both platforms.

To the same time when Dynamic Frameworks were introduced, Apple also introduced Swift. If you have third-party dependencies in Swift, you have only two choices: Either throw them in your project and compile one fat binary, which is no practical solution as this increases build times by the lack of incremental compilation and makes it hard to generically manage very different dependencies, which could require different build settings etc. Or you can facilitate frameworks. Static libraries are not an option anymore.

Why is that the case? Because Swift is still very open in design and subject to heavy changes. Unlike Objective-C, Apple doesn't ship the Swift standard runtime libraries with iOS. This decouples the language version from the platform version. When you build an app with Swift, you're responsible yourself to ship them. The toolchain provides at this place `swift-stdlib-tool`, which [covers the common use cases](http://samdmarshall.com/blog/swift_and_objc.html). As those libraries can't be statically linked multiple times, and not at all in different versions. Furthermore it is desirable to embed them only once and not embedded multiple times, because of constraints to memory size and network speed, which are relevant for distribution.

With this release, we initially allow to use both in combination with CocoaPods. Your project will automatically migrated or integrated, if you depend on a pod which includes Swift source code.
Furthermore you can use it, if your deployment target on iOS is greater then 8.0 or you're targeting the OS X platform, by specifying `use_frameworks!` in your Podfile.
This is an all or nothing approach per integrated target, because as we will later see, we can't ensure to properly build frameworks, whose transitive dependencies are static libraries.
So this release goes along with probably one of the most drastic change set on the whole project, which makes no stop on CocoaPods itself, but also required similar changes to Xcodeproj as well.


## Dynamic Frameworks vs. Static Libraries

![Xcode Template/Product Icons]()

So what's the difference between those both product types?

Dynamic Frameworks are bundles, which basically means that they are directories, which have the file suffix `.framework` and Finder treats them mostly like regular files. If you tap into a framework, you will see a common directory structure:

![Screenshot of BananaKit]()

They bundle some further data besides a binary, which is in that case dynamically linkable and holds different slices for each architecture. But that's only part, which static libraries covered so far. Belong the further data, there are the following:

* The public headers, which are stripped from the bundle for application targets, as those are only important to distribute the interface of the code for compilation. The public headers also include the generated headers for public Swift symbols, e.g. `Alamofire-Swift.h`.
* A code signature over the whole contents, which has to be (re-)calculated on embedding a framework into an application target, as the headers are stripped before.
* The resources, which are used by e.g. UI components, which the frameworks brings with it
* It can carry further dynamic frameworks and libraries, like e.g. the Swift runtime library. But since Xcode 6-beta7 dynamic frameworks don't include anymore the Swift runtime, they were compiled with, because this would led to duplication, if multiple frameworks are used. [We had to care about]() embedding all needed Swift runtime libraries only once into the application project.
* The clang module map, which is mostly an internal toolchain artifact, which carries declarations about header visibility and module link-ability.
* An Info.plist, which specifies author, version and copyright information.


### Caveats

One caveat about bundling resources is, that until now we had to embed all resources into the application bundle. This is referenced programmatically by `[NSBundle mainBundle]`. You as Pod author were able to use that kind of referencing to include resources you brought into the app bundle. But with frameworks, you have to make sure, that you reference them more specifically by getting a reference to your bundle like that:

```objective-c
[NSBundle bundleForClass:<#ClassFromPodspec#>]
```

```swift
NSBundle(forClass: <#ClassFromPodspec#>)
```

This will then work for both ways of integration.
There are only very rare cases, where you want to reference the main bundle directly or indirectly, e.g. by using `[UIImage imageNamed:]`.

The advantage, we have now with the improved resource handling is, that resources wouldn't conflict when they have the same names, because they are namespaced by the framework bundle. Furthermore we don't have to apply anymore the build rules ourself to the resources as e.g. asset catalogs and storyboards need to be compiled.


### More about Frameworks

If you want learn more about Frameworks, take a look into the [Framework Programming Guide](https://developer.apple.com/library/mac/documentation/MacOSX/Conceptual/BPFrameworks/Frameworks.html#//apple_ref/doc/uid/10000183-SW1). Even when this was not written specifically for the new Cocoa Touch Frameworks, how Apple calls them in their Xcode target template, those are mostly the same to the classic OS X frameworks, so this document is still a helpful introduction.


## What is special about Frameworks integrated by CocoaPods?

With CocoaPods Frameworks are mostly setup like you would setup them yourself in Xcode to make the entire integration inspectable and understandable. In addition this allows to unleash the power of the whole existing toolchain, because a lot of the tools play only nice together in an Xcode environment where certain build variables are present. Cocoa Touch Frameworks use by default under the hood clang modules, which are also required to link them to your Swift app. Therefore their module map is included. This module map is a declaration of the headers, which form the public and optionally the private interface of the module. Luckily, those have been designed so that they can stay in the background and the developer can faciliate known and existing structures, without having to learn their DSL. The default modulemap looks basically always the same:

```c
framework module BananaKit {
  umbrella header "BananaKit.h"

  export *
  module * { export * }
}
```

This references only one file explicitly: the umbrella header.
You can simply export as public API for your framework everything which was imported by the umbrella header and *all transitive imported* headers. Clang will take care for you that those will be made available as module exports and can be imported by Objective-C and Swift.

### What are Umbrella Headers?

For our example it could look like this:

```c
#import <Foundation/Foundation.h>

@import Monkey;

#import "BKBananaFruit.h"
#import "BKBananaPalmTree.h"
#import "BKBananaPalmTreeLeaf.h"

FOUNDATION_EXPORT double BananaKitVersionNumber;
FOUNDATION_EXPORT const unsigned char BananaKitVersionString[];
```

Their original purpose is to index all public headers of a directory to have a shorthand for imports/includes to access the full API of a library.
They began to cover more and more purposes:

* With **(Cocoa Touch) Frameworks**: they allow in addition quick access to versioning values defined in their Info.plist by on-the-fly generated C code. Therefore they have to define an interface to make them accessible. These are the constant declarations found in the Xcode template prefixed by `FOUNDATION_EXPORT`.
* With **Clang modules**: they are used to define the public interface of a module.
* With **Swift**: they are at the same time the bridging header which imports all what is needed from the (Objective-)C world.


### Current Situation with existing Podspecs

There has been never such a thing like a official dedicated and declarable Umbrella Header in Xcode. So pod authors never had to take care, that they have one public header, which imports *all* other public headers *transitively*. That's reason, why we take responsible and generate a custom Umbrella Header (e.g. `Pods-iOS Example-AFNetworking-umbrella.h`). This is injected by a custom module map, so that we don't run into name ambiguities, because otherwise the default module map would assume it has the same name like the framework, which could already been taken. Our generated header imports all declared public headers. This also defines the `FOUNDATION_EXPORT`s for the versioning constants, with the name which is used by CocoaPods for the framework to integrate. Furthermore this avoids problems in some special cases: e.g. AFNetworking itself has a subspec, which provides categories for UIKit, which provides an own mass-import header `AFNetworking+UIKit.h`, which isn't imported by the `AFNetworking.h` header for OSX-compatibility. To use this subspec in Swift, without a generated umbrella header, you would need to create a bridging header and use an import like `#import <AFNetworking/AFNetworking+UIKit.h`. With the generated umbrella header, you just need to `import AFNetworking`, if you have the subspec included in your Podfile. If your pod shouldn't work out of the box, you can use `pod lib lint --framework <YourPod.podspec>`, to check what is wrong. We tried that with different popular pods and sometimes ran into issues caused by misconfigured public headers.

#### About Public Headers

Public Headers in Podspecs are declared by `s.public_header_files = ["Core/*.h", "Tree/**.h"]`.

If you don't include this specification, then all your headers are public.
You need then to make sure, that you only

If you have an header like this:

```objectivec
/// BKBananaFruit.h

#import "monkey.h"

@interface BKBananaFruit
- (void)peel:(Monkey *)monkey;
@end
```

And you get an error like below, don't let you fool.

```
Include of non-modular header inside framework module 'BananaKit.BKBananaFruit'
```

You can include headers inside frameworks, but not quoted headers, which are not in scope of the framework itself in public headers. So you have two choices in this case: Either make the header `BKBananaFruit.h` private by excluding it from the public header declaration or use a system import to import the monkey.

```diff
-#import "monkey.h"
+#import <monkey/monkey.h>
```


## Updating

To install the last release of CocoaPods you can run:

```bash
$ [sudo] gem install cocoapods
```

Until version 1.0 we strongly encourage you to keep CocoaPods up-to-date.

For all the details, don’t miss the
[Changelog](https://github.com/CocoaPods/CocoaPods/blob/master/CHANGELOG.md)!
