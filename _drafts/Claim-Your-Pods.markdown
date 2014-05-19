---
layout: post
title:  "Claim Your Pods"
author: keith
categories: cocoapods trunk breaking
---

Today we are introducing the ‘Trunk’ web-service. An awesome new way for podspec
authors to submit their libraries to the master specs repository. For
authors who have previously had push access the workflow should be very
similar using the `pod push` subcommand. For more information on the ‘Trunk’
web-service itself, see [the previous blog post](http://blog.cocoapods.org/CocoaPods-Trunk/).

Along with these changes we are adding a hierarchy of ownership to
submitted podspecs. This way library maintainers will have complete
control over submissions of their specs to the master repo.

<!-- more -->

Moving forward this ownership will be determined by the first user to
submit a new spec. With existing podspecs, granting ownership will be a
little more complicated.


## Claim your Pod
### Claim submission

For the next few days we will be taking applications from spec authors
to claim their pods. This will set initial ownership for your libraries
within the ‘Trunk’ web-service allowing you, and the people you allow, to push new
specs for the given library. To do this we'll need you to fill out
this [form](https://trunk.cocoapods.org/claims/new) with the email address 
you would like use to identify with as an owner and the pod name you're 
claiming. Be sure to use the email address you use with Github so the 
commit logs will show your Github account.


### Claim collisions

In the case that someone has already submitted a claim for the pod you
are claiming we'll have to grant ownership differently. If you are one
of many maintainers of the pod, it's likely that your co-maintainers have
already gained ownership to the repo and can add you.


### Co-maintainer access

If you maintain a spec along with a few other contributors you can all
be added as owners to that spec. The initial owner can add other
contributors through the [command line interface](http://guides.cocoapods.org/making/getting-setup-with-trunk).


## Moving forward

We will take submissions for ownership until most specs have owners. We
estimate this will take a week or so.

After this any new specs you submit will default to your ownership. In
the future ownership claims will be handled by the CocoaPods dev team. 
One important side effect of this new workflow is how submitting pods 
will change besides just using the `push` command. 

Currently many spec authors rely on Travis to validate the correctness 
of their new spec versions. _We will no longer be using Travis for CI builds._ 
When submitting a new version of your podspec the command line tool will 
run a local `pod spec lint` verifying the spec's validity locally. 

After submitting a new version of a spec any revisions to that version must 
be submitted as a pull request to the [master repo](https://github.com/CocoaPods/Specs). 
Because of this I would recommend that you thoroughly test your spec with the linting
[tools](http://guides.cocoapods.org/terminal/commands.html#pod_lib_lint)
and by using it in your real applications and/or demo applications to make sure
everything works as expected. This is _your_ responsibility from hereon out.
