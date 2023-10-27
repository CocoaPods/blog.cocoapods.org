---
layout: post
title:  "CocoaPods Trunk: 3 Remote Code Execution found, 2023"
author: orta
categories: cocoapods trunk
---

Over the last month, security researchers at [evasec.io](https://evasec.io) have been reached out to us about three separate vulnerabilities in CocoaPods Trunk. We've been working with them to patch these  issues as they come up. Looking at all three combined, I felt we needed to reset the user sessions again, which is why I'm writing on the blog post instead of [working on Puzzmo](https://www.theverge.com/23929222/puzzmo-newspaper-games-crossword-zach-gage) which just shipped this week.

The three issues key issues reported, and fixed, are:
 
 - 1. It was still possible to use the ['claim your pod'](https://blog.cocoapods.org/Claim-Your-Pods/) process to take over a Pod when someone had removed all prior maintainers from it
 - 2. The part of trunk which verifies your email address is real could be used to execute shell commands on the trunk server
 - 3. The email which is sent out to verify your email address can be tricked with headers to change to link to a third party

Being able to execute arbitrary shell commands on the server gave a possible attacker the ability to read the environment variables, which could be used to write to the CocoaPods/Specs repo and read the trunk database. Being able to trick people into clicking on a link which would take them to a third party site could be used to steal their session keys. I can't guarantee neither of these happened, and I'd rather be on the safe side.

**This means you will need to log in again to trunk again to deploy any new Podspecs**. If you have automated deployment to CocoaPods working with a stored ENV VAR right now, **this will break**, and you will need to `pod trunk register` again and replace your `COCOAPODS_TRUNK_TOKEN`. We're sorry, I know that sucks, but it also _guarantees_ that you are the only person with write access to your pods.

If you are not a pod author, you do not need to do anything.

<!-- more -->

Let's look at each issue in turn.

### 1. Claim your pod

When we shipped CocoaPods trunk in  2014, there were already a lot of pods in CocoaPods but no authentication system for folks because they were sending Pull Requests. CocoaPods was a small community with most folks knowing each other. We added a feature where you could 'claim' that you owned an existing pod, and if no-one had claimed it because it had no ownership, then it was yours. This worked without a hitch, but we never went back to remove this feature as the community grew. 

There were still a few older pods which had never been claimed, and I think more importantly, there were pods where folks had fully removed everyone from the owners list. This meant that anyone could take over that CocoaPod once it had no owners. We've removed the claim feature from Trunk. 

EVA reported this on September 20th, and we had it fixed within 2 days. 

### 2. Verify email MX RCE

To verify that an email address that someone requested to use was something which we could send to, we relied on a library for validating the email address. This library calls the OS's `host` command to handle some of that work. [Host is a DNS tool](https://en.wikipedia.org/wiki/Host_(Unix)) installed on most Unix systems which can use used to verify the domain exists. The library does not sanitize the input, so it was possible to inject shell commands into the lookup process. 

This worked by submitting to trunk that you had an 'email address' which could successfully pass the `host` lookup, but still continue execution into the bash shell. At that point you have full server access.

EVA reported this on September 20th, and we had it fixed within 2 days.

### 3. Email header injection

When you register for a CocoaPods account, we send you an email which you need to click to verify that you own the email address. This email contains a link which is templated from the URL which requested it. e.g. You are sending a HTTP request to `trunk.cocoapods.org` to create your account, to the server that request will have said to come from `trunk.cocoapods.org`. This lets us have a staging, or dev URL instead and the link sent to the email would be consistent with the URL you submitted your request with. However, there is a part of the HTTP stack where this can be overridden using the [request header `X-Forwarded-For`](https://en.wikipedia.org/wiki/X-Forwarded-For). Giving you chance to change the URL which would be sent _to a third party_.

EVA reported this on October 26th, and we had it fixed in under 24 hours.

### Worst case scenario

Like with the [RCE in 2021](https://blog.cocoapods.org/CocoaPods-Trunk-RCE/) I can't prove these have been exploited. However, just because it hasn't been proved, doesn't mean it hasn't happened. 8 years is a long time for these to have existed in trunk. 

The worst case scenario is that an attacker could have used this technique to get access to our trunk database. The trunk database contains the same emails which are public in the git history of the Specs repo. The table of information in the database which should not be seen are session keys. These keys act like unique passwords to accounts, and session keys are used to connect authenticated users to pods. We are wiping all session keys.

### For more information

CocoaPods is ran by a set of volunteers in their spare time. If you have any questions or comments about this advisory:

* Open an issue in [the trunk repo](https://github.com/CocoaPods/trunk.cocoapods.org)
* Email us at our private security email: [info@cocoapods.org](mailto:info@cocoapods.org)

If you're not sure of the email address you used to use, use `pod trunk info [pod_name]` to see the connected email accounts.
