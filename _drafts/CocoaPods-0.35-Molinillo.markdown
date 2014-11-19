---
layout:     post
title:      "CocoaPods 0.35 and Molinillo"
date:       2014-11-03
author:     samuel
categories: cocoapods releases
---

TL;DR: _CocoaPods 0.35_ has been released, with major improvements to the dependency resolution process, [thanks to Stripe's support] (https://stripe.com/blog/stripe-open-source-retreat). Making the 0.35 release possible is the concurrent release of [Molinillo](https://github.com/CocoaPods/Molinillo) 0.1, our new dependency resolution module.

<!-- more -->

The CocoaPods 0.35 is much more limited in scope than [0.34 was](http://blog.cocoapods.org/CocoaPods-0.34/), but the improvements in this version center on the heart of what CocoaPods is: a dependency manager. While the list of new features may seem short, don't be disappointed: this is a major step forward for CocoaPods.

## Dependency Resolution

At the heart of any dependency managers is its `Resolver`, whose job is to take a list of dependencies (defined in a `Podfile`) and transform those explicit  requirements into a complete set of Pods to install. With CocoaPods 0.35, the core dependency resolution code has been completely rewritten, giving birth to Molinillo, a generic dependency resolution module. This change should improve the experience of using CocoaPods by making things work in a more predictable manner and allowing you to focus more on your project instead of making things easier for CocoaPods.

### Automatic Conflict Resolution

Consider the following `Podfile` and note that CocoaPods will by default, when no version requirements are specified, try to activate the latest available version of a pod. (The versions in this example are based on the latest available versions of the pods in question _at the time of writing_).

```ruby
pod 'AFAmazonS3Client' # Version 2.0.0 activates AFNetworking with requirements: >= 2.0.0 && < 3.0.0
pod 'CargoBay'         # Version 2.1.0 activates AFNetworking with requirements: >= 2.2.0 && < 3.0.0
pod 'AFOAuth2Client'   # Version 0.1.2 activates AFNetworking with requirements: >= 1.3.0 && < 2.0.0
```

On prior versions of CocoaPods, attempting to `pod install` would yield an error saying `Unable to satisfy the following requirements` since the latest versions of all three pods have incompatible dependencies on different versions of AFNetworking. With the old resolver, we would naïvely try to activate the latest spec version for the first dependency and continue from there, which would lead to a conflict, since there was no way to get to an older version of `AFNetworking` (or any of the pods that depended upon it). No more. With the transition to [`Molinillo`](https://github.com/CocoaPods/Molinillo), a generic dependency resolution gem I've been writing at Stripe, Podfiles like this will have such conflicts automatically resolved. 

Let's take a look at the same `Podfile` in CocoaPods 0.35:

```ruby
pod 'AFAmazonS3Client' # Version 1.0.1 activates AFNetworking with requirements: >= 1.3.0 && < 2.0.0
pod 'CargoBay'         # Version 1.0.0 activates AFNetworking with requirements: >= 1.0.0 && < 2.0.0
pod 'AFOAuth2Client'   # Version 0.1.2 activates AFNetworking with requirements: >= 1.3.0 && < 2.0.0
```

From the above, it is clear that the latest versions of `AFAmazonS3Client` and `CargoBay` are not compatible with the requirements of `AFOAuth2Client`. As such, the new resolver will now __backtrack__ and try to satisfy the requirements of `AFOAuth2Client` by looking for __older__ versions of `AFAmazonS3Client` and `CargoBay` that are compatible with `AFNetworking` versions between `1.3.0` and `2.0.0`, thus activating `AFNetworking` version `1.3.4` and correctly satisfying all of the dependencies in the `Podfile`.

The resolver is now able to backtrack when conflicts arise, thus allowing it to simultaneously satisfy all dependency constraints, or definitely state that the Podfile is unresolvable. The development of a [language-agnostic resolver integration suite](https://github.com/CocoaPods/Resolver-Integration-Specs) made this possible, and will hopefully ensure that other dependency managers can provide a consistent resolution process.

### Improved Locking

CocoaPods has always had a version locking feature (it's your `Podfile.lock`) that tries to ensure that, whenever someone clones a project and runs `pod install`, they will get the same dependency versions as you. Well, in CocoaPods 0.35, that version locking has been extended to _implicit_ dependencies as well, so your `Podfile.lock` is now an absolute source of truth.

### Pre-Release Dependencies

At CocoaPods, we love it when people make pre-release versions of their libraries -- we do it ourselves! In order to more strictly conform with [Semantic Versioning](http://semver.org), pre-release versions of a Pod will now only be considered in the resolution process if there is any dependency on the pod with a pre-release version in its requirement.

Thus, if you want a pre-release version, such as a beta, you will have to specify that in your Podfile, like so:

```ruby
pod 'AFNetworking', '~> 2.0.0-RC1'
```

### External Source Optimizations

Handling of dependencies with external sources (e.g., `pod 'RestKit', git: 'https://github.com/RestKit/RestKit.git'`) has been optimized and clarified in this release. CocoaPods now only downloads each Pod with an external source once, which has the nice side effect of making linting specifications that have a lot of subspec dependencies faster. CocoaPods also lets you know when there are conflicting dependencies, so you can remove unwanted duplication from your `Podfile`. Finally, CocoaPods lets you know if you specify the same Pod with different external sources, instead of a random source being chosen.

### Locking Checkout Options

At the intersection of improved locking and external source optimizations is CocoaPods 0.35’s final feature: the lockfile now hold the information necessary to ensure that dependencies directed installed from a repository will be locked to the same revision until updated. That means this Podfile, along with its corresponding Podfile.lock, will ensure that every member of your team is always on the same revision of _all_ of your dependencies:

```ruby
pod 'AFNetworking', :git => 'https://github.com/AFNetworking/AFNetworking.git'
pod 'RestKit', :git => 'https://github.com/RestKit/RestKit.git', :branch => 'development'
pod 'ARAnalytics', '~> 2.9.0'
```

`AFNetworking` will continue to use the same commit that was downloaded when you first ran `pod install`, so you don’t have to worry about changes sneaking in when you run `pod install` on a new machine. As always, `pod update AFNetworking` will update you to the latest commit.

## Performance Improvements

Molinillo makes resolving a normal application's Podfile roughly [1.5x faster](https://github.com/CocoaPods/CocoaPods/pull/2637#issuecomment-60422101) than the old resolver, which is astonishing given the wider breadth of its feature-set. Additionally, the external source optimizations should make fetching multiple subspecs from an external source many times faster.

The vast majority of this release's performance improvements come from [Eloy's](https://github.com/alloy) work on optimizing expensive operations in [Xcodeproj](https://github.com/CocoaPods/Xcodeproj). This makes CocoaPods' integration steps blaze by!

## Updating

To install the last release of CocoaPods you can run:

```bash
$ [sudo] gem install cocoapods
```

Until version 1.0 we strongly encourage you to keep CocoaPods up-to-date.

For all the details, don’t miss the
[Changelog](https://github.com/CocoaPods/CocoaPods/blob/master/CHANGELOG.md)!
