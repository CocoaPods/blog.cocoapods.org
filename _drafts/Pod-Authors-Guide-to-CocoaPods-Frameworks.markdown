---
layout: post
title:  "Pod Authors Guide to CocoaPods Frameworks"
author: marius
categories: cocoapods releases
---

TL;DR: _CocoaPods 0.36_ will bring the long-awaited support for Frameworks and Swift.
It isn't released and considered stable yet, but a prerelease is now available for everyone.
Especially pod authors can use that to make sure their pods will work with the official release.

<!-- more -->

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

#import "BKBananaTree.h"
#import "monkey.h"

@interface BKBananaFruit
@property (nonatomic, weak) BKBananaTree *tree;
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

To install the latest Release Candidate of CocoaPods you can run:

```bash
$ [sudo] gem install cocoapods --prerelease
```

Until version 1.0 we strongly encourage you to keep CocoaPods up-to-date.

For all the details, take a look into the
[PR](https://github.com/CocoaPods/CocoaPods/pull/2835)!
