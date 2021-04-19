---
layout: post
title:  "CocoaPods Trunk: Remote Code Execution found"
author: orta
categories: cocoapods trunk
---

Part of the server-side validation for uploading a new CocoaPod to the central repository of Podspecs [(trunk)](https://blog.cocoapods.org/CocoaPods-Trunk/) could be exploited to execute arbitrary shell commands on the trunk server. 

We were contacted via [Max Justicz](https://mastodon.mit.edu/@maxj) this morning who provided us with a great technical write-up and showed how to trigger it for ourselves. The exploit is a combination of un-sanitized user input getting through to a git call param which can be used to send remote payloads. 

Being able to execute arbitrary shell commands on the server gave a possible attacker the ability to read the environment variables, which could be used to write to the CocoaPods/Specs repo and read the trunk database.

**This means you will need to log in again to trunk again to deploy any new Podspecs**. If you have automated deployment to CocoaPods working right now, **this will break**, and you will need to `pod trunk register` again and replace your `COCOAPODS_TRUNK_TOKEN`. We're sorry, I know that sucks, but it also _guarantees_ that you are the only person with write access to your pods.

If you are not a pod author, you do not need to do anything.

<!-- more -->

### Patched

This vulnerability was introduced on [Jun 4th, 2015](https://github.com/CocoaPods/trunk.cocoapods.org/pull/137) and has been fixed as of [11am GMT April 19th 2021](https://github.com/CocoaPods/trunk.cocoapods.org/pull/303). The issue has been patched server-side and does not affect your CocoaPods installation.

As most of the commits in the Specs repo are automated through trunk, we have [built some introspection tools](https://github.com/orta/specs-repo-git-scanner) to validate the Specs repo commits are ones which have been created by publishing/deprecating/deleting through trunk. The majority of other commits in the repo are around setting up infra for the CDN support, and CocoaPods release pushes. We don't think the CocoaPods Specs repo has been tampered with.

### How the exploit worked

During the deploy of a podspec to trunk, the server validates that the repo is accessible to git. This is done to help fix potentially broken podspecs with typoes, local auth which won't work for others or external repos don't have tags already set up. This validation used to rely on using the git CLI on trunk using `git ls-remote` to replicate the same check as a user's git would, but `ls-remote` has a parameter [`--upload-pack`](https://git-scm.com/docs/git-ls-remote) which can be used to execute a new shell.

This meant an attacker could create a specially crafted podspec via [`source`](https://guides.cocoapods.org/syntax/podspec.html#source), which would trigger the `--upload-pack` param and execute an arbitrary command on trunk.

### Worst case scenario

We've not been able to prove that anyone has used this method before Max's report today. However, just because it hasn't been proved, doesn't mean it hasn't happened. 6 years is a long time. 

The worst case scenario is that an attacker could have used this technique to get access to our trunk database. The trunk database contains the same emails which are public in the git history of the Specs repo. The table of information in the database which should not be seen are session keys. These keys act like unique passwords to accounts, and session keys are used to keep authenticate users to pods. We are wiping all session keys.

From the side of our investigation, _we cannot automatically detect if someone has deployed a poisoned copy of a Pod_. If want to verify that your Pods have not had an un-expected release, you can use this app to shows the `sources` for every version of a Pod: https://3km05.csb.app

### For more information

If you have any questions or comments about this advisory:

* Open an issue in [the trunk repo](https://github.com/CocoaPods/trunk.cocoapods.org)
* Email us at our private security email: [info@cocoapods.org](mailto:info@cocoapods.org)
