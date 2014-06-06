---
layout: post
title: "Stripe's Open Source Retreat"
author: samuel
categories: sponsorship cocoapods
---

Today, I am beyond excited to announce that I will be working full-time on CocoaPods this autumn, courtesy of Stripe's [Open Source Retreat](https://stripe.com/blog/open-source-retreat-grantees).

For three months, in addition to my normal work on CocoaPods, I will be working to write a reference implementation of an iterative dependency resolver that will be shared by CocoaPods and [Bundler](https://bundler.io/) (and available to any developer that wants to use it).
As part of the project, I will also be writing a language-agnostic test suite to help standardize behavior across different implementations of resolvers.

<!-- more -->

Ever since I first joined GitHub, I have dreamed about writing open source software for a living. Stripe is both making my dream a reality and truly supporting great open source work.

Since joining the CocoaPods Core team two months ago, I have set my eyes on the resolver.
Right now, it has a 'naive' implementation: we just go through the dependencies list and pick the highest version that 'fits' with the current requirements.
The right way to do this is to add automatic conflict resolution: when we run into a versioning conflict, we need to 'back up' and try another set of versions.
This is a tough algorithmic problem, and exploring the best way to do it (both in terms of algorithm and architecture) has prevented us from tackling it before now.
With this rewrite, we will be a giant leap closer to CocoaPods 1.0.

Come September, I will be in San Fransisco, taking a year off of university, working on CocoaPods full-time. This means I'll be working on even more issues, contributing more features, and hopefully writing a few interesting updates on my progress.

The entire CocoaPods team and I are incredibly grateful to [Stripe](https://stripe.com/) for supporting our work and sharing our visions for the future of open-source.
