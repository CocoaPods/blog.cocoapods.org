---
layout: post
title:  "Claim Your Pods"
date:   2014-02-05
author: keith
categories: cocoapods
---

Today we are introducing the trunk app. An awesome new way for podspec
authors to submit their libraries to the master specs repository. For
authors who have previously had push access the workflow should be very
similar using the `pod push` subcommand.


Along with these changes we are adding a hierarchy of ownership to
submitted podspecs. This way library maintainers will have complete
control over submissions of their specs to the master repo.


Moving forward this ownership will be determined initially by the first
user to submit a new spec. With existing podspecs the ownership will be
a little more complicated.


## Claim your Pod
### Claim submission

For the next few days we will be taking applications for spec authors to
claim their pods. This will add set initial ownership for your libraries
within the trunk app allowing you, and the people you grant access, to
push new specs for your library. **To do this we'll need you to submit
(how?) a small amount of information, the email address you would like
to identify you as an owner and the pod name you're claiming.**

### Claim collisions

In the case that someone has already submitted a claim for the pod you
are claiming we'll have to grant ownership differently. If you are a one
of many maintainers of the pod it's likely that your co-maintainers have
already gained ownership to the repo and can add you as a owner as well.

If someone who you believe shouldn't be the owner of a pod has gained
ownership, please send us (how?) a *short* description of what is going
on along with the pod's name and what you believe should be the correct
ownership email address.

### Co-maintainer access

If there are multiple people who maintain your library's spec, you can
add them all as owners to the spec. (Instructions?)


## Moving forward

We will take submissions for ownership for the next few days. After this
any new specs you submit will default to your ownership. In the future
ownership claims will be handled by (?).
