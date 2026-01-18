---
layout: post
title: "CocoaPods Trunk: Minor security updates"
author: orta
categories: cocoapods trunk
---

Hey folks, strange enough we got two separate security folks pointing out the same flaw in Trunk within a week of each other. I've shipped a fix this morning and thought it was worth both explaining what was fixed and giving credit to the two researchers: [splitline](https://github.com/splitline) fom DEVCORE and [Joshua Roger](https://joshua.hu/)

<!-- more -->

When you sign up to CocoaPods trunk, rather than having you set up a password in the CLI we email you a token which you click to verify your current session as being valid. So you would register with:

```
> pod trunk register orta.therox@gmail.com
[!] Please verify the session by clicking the link in the verification email that has been sent to orta.therox@gmail.com
```

That verification email would look like:

```
Hi Orta Therox,

Please confirm your CocoaPods session by clicking the following link:

    https://trunk.cocoapods.org/sessions/verify/51efd813

If you did not request this you do not need to take any further action.

Kind regards,
the CocoaPods team
```

Accepting the token by clicking the link sets up the authentication for my local CLI as being verified.

The flaw here is that `51efd813` is a _relatively_ small space of characters, and we didn't have any protection around someone requesting a verification for basically every possible token (e.g. `11111111` to `ffffffff`.)

[splitline](https://github.com/splitline) fom DEVCORE sent me a very interesting way to think about it, with a proof of concept script by ding a [birthday attack](https://en.wikipedia.org/wiki/Birthday_attack).

Step 1: Register a lot of times for the email you want, to increase the odds of it working.
Step 2: Send random verification requests to Trunk
Step 3: Check all of the sessions to see if they were verified

With a reasonable enough amount of time, and tens of thousands of requests on each step, you can verify a token for an email address you don't own.

## The fix

The [Pull Request is here](https://github.com/CocoaPods/trunk.cocoapods.org/pull/601) which converts the 8 characters to 20 characters (making the search space significantly larger) and adding the verification system to our request throttler, making it much harder to search the space!

### Worst case scenario

Like with the [RCE in 2021](https://blog.cocoapods.org/CocoaPods-Trunk-RCE/) I can't prove this hasn't been actively used. However, just because it hasn't been proved, doesn't mean it hasn't happened. This touches code which has been in trunk since launch, and 11 years is a long time.

The worst case scenario is that an attacker could have used this technique to get access to upload a CocoaPod version which contains malicious code. For a few years now we've been emailing Podspec authors when a new version comes out, so it's likely someone would have been notified if this has happened to them.

### For more information

We want to offer our thanks to [splitline](https://github.com/splitline) fom DEVCORE and [Joshua Roger](https://joshua.hu/) for their thorough reporting! They mentioned a few other things not noted in this blog post but we fixed around XSS and our throttler.

CocoaPods is ran by a set of volunteers in their spare time. If you have any questions or comments about this advisory:

- Open an issue in [the trunk repo](https://github.com/CocoaPods/trunk.cocoapods.org)
- Email us at our private security email: [info@cocoapods.org](mailto:info@cocoapods.org)

If you're not sure of the email address you used for a pod, use `pod trunk info [pod_name]` to see the connected email accounts.
