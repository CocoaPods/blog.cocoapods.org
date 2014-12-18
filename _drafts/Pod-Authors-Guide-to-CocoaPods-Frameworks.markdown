---
layout: post
title:  "Pod Authors Guide to CocoaPods Frameworks"
author: marius
categories: cocoapods releases
---

TL;DR: _CocoaPods 0.36_ will bring the long-awaited support for Frameworks and Swift.
It isn't released and considered stable yet, but a prerelease is now available for everyone.
Pod authors especially will want to try this to make sure their pods will work with the official release. Because if a single dependency in a user's project requires a framework, then your Pod will also become a framework.

<!-- more -->

## What is special about Frameworks integrated by CocoaPods?

With CocoaPods, Frameworks are mostly setup in way similar to how it is done via Xcode.
This is to make the entire integration inspectable, understandable and allows us to unleash the power of the whole existing toolchain.
A lot of the tools play only nice together in an Xcode environment where certain build variables are present.
Cocoa Touch Frameworks for example use clang modules, which are also required to import and link them to your Swift app.

This module map is a declaration of the headers, which form the public (or private) interface of the module.
Luckily, those have been designed so that they can stay in the background and the developer can faciliate known and existing structures, without having to learn their DSL.
The default modulemap looks basically always the same:

```c
framework module BananaKit {
  umbrella header "BananaKit.h"

  export *
  module * { export * }
}
```

This references only one file explicitly: the umbrella header.
You can simply export as public API for your framework everything which was imported by the umbrella header and *all transitive imported* headers.
Clang will take care making module exports that can be imported by Objective-C and Swift.


### What Means *Transitive Imported* In This Context?

Transitive relations are a [concept from mathematics](http://en.wikipedia.org/wiki/Transitive_relation):

>Whenever an element *a* is related to an element *b*, and *b* is in turn related to an element *c*, then *a* is also related to *c*.

We have here the binary relation of a header file, which imports another header file.
The transitive closure means that all headers, which are imported by header files, which you have imported from a certain file are indirectly imported to that file, too. That's also the same for all header files, which are imported by the collection of those headers.
Surely, you know this property from your app target, whenever you import a header, which imports other headers, the classes and symbols, which are defined there, are also available in your app code.
The same has to apply for import statements in Umbrella Headers and effect the module visibility with Clang modules.


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

There has never been a declarable Umbrella Header in Xcode.
So Pod authors have never had to specify one.
Though it has always been a known pattern to have one public header, which imports *all* other public headers *transitively*.
This isn't always the case.

For this reason, we take responsibility and generate a custom Umbrella Header (e.g. `Pods-iOS Example-AFNetworking-umbrella.h`). This is injected by a custom module map, so that we don't run into name ambiguities. Otherwise the default module map would assume it has the same name as the framework, which could already been taken.

Our generated header imports all declared public headers. This also defines the `FOUNDATION_EXPORT`s for the versioning constants, with the name which is used by CocoaPods for the framework to integrate. Furthermore this avoids problems in some special cases: e.g. AFNetworking has a subspec, which provides categories for UIKit, which provides an own mass-import header `AFNetworking+UIKit.h`, which isn't imported by the `AFNetworking.h` header for OSX-compatibility.

To use this subspec in Swift, without a generated umbrella header, you would need to create a bridging header and use an import like `#import <AFNetworking/AFNetworking+UIKit.h`. With the generated umbrella header, you just need to `import AFNetworking`, if you have the subspec included in your Podfile. If your pod shouldn't work out of the box, you can use `pod lib lint --framework <YourPod.podspec>`, to check what is wrong. We tried that with different popular pods and sometimes ran into issues caused by misconfigured public headers.


#### About Public Headers

Public Headers in Podspecs are declared by `s.public_header_files = ["Core/*.h", "Tree/**.h"]`.

If you don't include this specification, then all your headers would be public.
This isn't recommeded in the most of the cases.

Generally you should make sure, that you have self-contained headers and only expose that part of  your implementation, which is consumed by your Pods users. This has several advantages:

* It allows you to refactor the private implementation part without necessarily releasing a major update, which makes the version migration easier and allows you to focus on further improving your pod instead of explain your users how the API has changed.
* It impedes misusage, because you would need to modify header access to use or manipulate classes or properties, which are not intended to be used externally.


#### Common Pitfalls

If you have an header like this:

```objectivec
/// BKBananaFruit.h

#import "BKBananaTree.h"
#import "monkey.h"

@interface BKBananaFruit
@property (nonatomic, weak) BKBananaTree *tree;
- (void)peel:(Monkey *)monkey;
@end
```

And you get an error like below, don't let it fool you.

```
Include of non-modular header inside framework module 'BananaKit.BKBananaFruit'
```

You can include headers inside frameworks, but not quoted headers, which are not in scope of the framework itself in public headers. So you have two choices in this case: Either make the header `BKBananaFruit.h` private by excluding it from the public header declaration or use a system import to import the monkey.

```diff
-#import "monkey.h"
+#import <monkey/monkey.h>
```


## Updating

To install the latest Release Candidate of CocoaPods you can run:

```bash
$ [sudo] gem install cocoapods --prerelease
```

Until version 1.0 we strongly encourage you to keep CocoaPods up-to-date.

For all the details, take a look into the
[PR](https://github.com/CocoaPods/CocoaPods/pull/2835)!
