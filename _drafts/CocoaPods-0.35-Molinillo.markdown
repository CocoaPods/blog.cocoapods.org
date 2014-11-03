---
layout:     post
title:      "CocoaPods 0.35 and Molinillo"
date:       2014-11-03
author:     samuel
categories: cocoapods releases
---

TL;DR: _CocoaPods 0.35_ has been released, with major improvements to the dependency resolution process, [thanks to Stripe's support] (https://stripe.com/blog/stripe-open-source-retreat). Making the 0.35 release possible is the concurrent release of [Molinillo](https://github.com/CocoaPods/Molinillo) 0.1.0.

<!-- more -->

The CocoaPods 0.35 is much more limited in scope than [0.34 was](http://blog.cocoapods.org/CocoaPods-0.34/), but the improvements in this version center on the heart of what CocoaPods is: a dependency manager. While the list of new features may seem short, don't be disappointed: this is a major step forward for CocoaPods.

## Dependency Resolution

At the heart of any dependency managers is its `Resolver`, whose job is to take a list of dependencies (defined in a `Podfile`) and transform those explicit  requirements into a complete set of Pods to install. With CocoaPods 0.35, the core dependency resolution code has been completely rewritten. This change should improve the experience of using CocoaPods by making things work in a more predictable manner and allowing you to focus more on your project instead of making things easier for CocoaPods.

### Automatic Conflict Resolution

Take a look at this `Podfile`:

```ruby
pod 'AFAmazonS3Client'
pod 'CargoBay'
pod 'AFOAuth2Client'
```

On prior versions of CocoaPods, attempting to `pod install` would yield an error saying `Unable to satisfy the following requirements`. No more. With the transition to [`Molinillo`](https://github.com/CocoaPods/Molinillo), a generic dependency resolution gem I've been writing at Stripe, Podfiles like this will have such conflicts automatically resolved. The development of a [language-agnostic resolver integration suite](https://github.com/CocoaPods/Resolver-Integration-Specs) made this possible, and will hopefully ensure that other dependency managers can provide a consistent resolution process.

### Improved Locking

CocoaPods has always had a version locking feature (it's your `Podfile.lock`) that tries to ensure that, whenever someone clones a project and runs `pod install`, they will get the same dependency versions as you. Well, in CocoaPods 0.35, that version locking has been extended to _implicit_ dependencies as well, so your `Podfile.lock` is now an absolute source of truth.

### Pre-Release Dependencies

At CocoaPods, we love it when people make pre-release versions of their libraries -- we do it ourselves! In order to more strictly conform with [Semantic Versioning](http://semver.org), pre-release versions of a Pod will now only be considered in the resolution process if there is any dependency on the pod with a pre-release version in its requirement.

### External Source Optimizations

Handling of dependencies with external sources (e.g. `pod 'RestKit', git: 'https://github.com/RestKit/RestKit.git'`) has been optimized and clarified in this release. CocoaPods now only downloads each Pod with an external source once, which has the nice side effect of making linting specifications that have a lot of subspec dependencies faster. CocoaPods also lets you know when there are conflicting dependencies, so you can remove unwanted duplication from your `Podfile`. Finally, CocoaPods lets you know if you specify the same Pod with different external sources, instead of a random source being chosen.

## Performance Improvements

Molinillo makes resolving a normal application's Podfile roughly [1.5x faster](https://github.com/CocoaPods/CocoaPods/pull/2637#issuecomment-60422101) than the old resolver, which is astonishing given the wider breadth of its featureset. Additionally, the external source optimizations should make fetching multiple subspecs from an external source many times faster.

The vast majority of this release's performance improvements come from [Eloy's](https://github.com/alloy) work on optimizing expensive operations in [Xcodeproj](https://github.com/CocoaPods/Xcodeproj). This makes CocoaPods' integration steps blaze by!

## Updating

To install the last release of CocoaPods you can run:

```bash
$ [sudo] gem install cocoapods
```

Until version 1.0 we strongly encourage you to keep CocoaPods up-to-date.

For all the details, don’t miss the
[Changelog](https://github.com/CocoaPods/CocoaPods/blob/master/CHANGELOG.md)!
