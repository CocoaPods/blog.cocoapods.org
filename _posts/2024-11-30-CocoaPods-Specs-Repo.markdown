---
layout: post
title:  "CocoaPods Trunk Read-only Plan"
author: orta
categories: cocoapods 
---

**TLDR: In two years we plan to turn CocoaPods trunk to be read-only. At that point, no new versions or pods will be added to trunk.**

Last month I wrote about how CocoaPods is currently being maintained, I also noted that we were discussing converting the main CocoaPods spec repo "trunk" to be read-only:

> We are discussing that on a very long, multi-year, basis we can drastically simplify the security of CocoaPods trunk by converting the Specs Repo to be read-only. Infrastructure like the Specs repo and the CDN would still operate as long as GitHub and jsDelivr continue to exist, which is pretty likely to be a very long time. **This will keep all existing builds working**.

I plan to implement the read-only mode so that when someone submits a new Podspec to CocoaPods, it will always be denied at the server level. I would then convert the "CocoaPods/Specs" repo to be marked as "Archived" on GitHub which should cover all of our bases.

Making the switch will not break builds for people using CocoaPods in 2026 onwards, but at that point, you're not getting any more updates to dependencies which come though CocoaPods trunk. This shouldn't affect people who use CocoaPods with their own specs repos, or have all of their dependencies vendored (e.g. they all come from npm.)

## Timeline

My goal is to send 2 very hard-to-miss notifications en-masse, and then do a test run a month before the final shutdown.

### Jan 2025

I will email all email addresses for people who have contributed a Podspec, informing them of the impending switch to read-only, and linking them to this blog post.

### September-October 2026

I will, again, email all email addresses for people who have contributed a Podspec, informing them of the impending switch to read-only, and linking them to this blog post, noting that they have roughly a month before we do a test run of going read-only.

### November 1-7th 2026

I will trigger a test run, giving automation a chance to break early

### December 2nd 2026

I will switch trunk to not accept new Podspecs permanently. This is a Wednesday after American Thanksgiving, so I think folks won't be in rush mode.

## Contact

These dates are not set in stone, and maybe someone out there has a good reason for us to amend the timeline. I don't think I'm amenable to moving it forwards, but within reason there's space for backwards.

If you have questions, you can contact the team via info@cocoapods.org, me personally at cocoapods@orta.io or reach out to me via Bluesky: [@orta.io](https://bsky.app/profile/orta.io/).
