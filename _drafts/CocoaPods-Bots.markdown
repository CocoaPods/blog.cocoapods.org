---
layout: post
title:  "CocoaPods and Xcode Bots"
author: michele
categories: cocoapods bots
---

Last WWDC, Apple announced a new feature shipping with Xcode 5 and OS X Server, called Bots. This continuous integration server was designed to build and test Mac and iOS projects with ease. It includes the ability to setup new integrations (re: projects) with Xcode, and provides a nice web-based dashboard for monitoring and configuring your builds.

<!-- more -->1

##Shortcut
This blog post is centered around getting `pod install` to run in a Scheme pre-action, which means the `Pods` folder is not checked in. As far as we have tested, **if you check in your `Pods` folder, Bots will just work.** But we know a number of users prefer to not have that folder in their repository ( author included), so this post explains the how and why to setting that up.

##Backstory
We started playing with Bots as soon as the first preview of Server was available for download. We are big fans of continuous integration, and wanted to make sure we had the right instructions for setting up CocoaPods to work with Bots. It quickly became obvious that Bots were doing something unexpected. 

Since they've come out, there have been a [number](http://matt.vlasach.com/xcode-bots-hosted-git-repositories-and-automated-testflight-builds/) [of](http://bjmiller.me/post/72937258798/continuous-integration-with-xcode-5-xctest-os-x) [blog](http://bjmiller.me/post/72937258798/continuous-integration-with-xcode-5-xctest-os-x) [posts](http://ikennd.ac/blog/2013/10/xcode-bots-common-problems-and-workarounds/) [about](http://blog.nitromobilesolutions.com/2013/11/continuous-integration-with-xcode-bots-part-1-initial-setup/) using Bots. If you're not familiar with getting your project setup with Bots, I suggest you take a look at a few of those posts. It's not exactly straightforward.

##Setup
Now that you're somewhat familiar with how Bots work, let's briefly discuss the technical problems we encountered while trying to get a Bot to run `pod install`. Here is the environment that you should have ready to go:

- Version-controlled `MyApp.xcworkspace` (or an `xcodeproj` if that is how your project is setup).
- Version-controlled `Podfile.lock`.
- A shared Scheme (Product > Schemes > Manage Schemes, make sure "Shared" is checked).
- CocoaPods installed on your machine running Server.

##Hurdles
There are some technical hurdles to getting this running. Here's a brief overview:

- When a Bot builds, it does not use the logged-in user, and instead runs as a different user, `_teamsserver`.
- Since there are no pre- or post-build actions within the Bot setup, we need to rely on Scheme Build pre-actions to do the heavy lifting.
- When debugging pre- and post- scheme actions, results/success/failure do not get logged anywhere. So we need to pipe these to a temporary file while debugging. They're literally a black box otherwise.
- The scripts we add to Schemes will be included, raw, in the project file. This is not always optimal.

###User
So this user `_teamsserver` needs some things setup for it to be able to run our scripts properly.

1. Make sure `/var/teamsserver` exists.
2. Make sure `_teamsserver` has w+r+x access to `/var/teamsserver`.

###Pre-actions
Scheme pre-actions are a very powerful tool. This lets us run an arbitrary bit of code before the build actually happens, which in this case runs `pod install`. The hardest part is making sure that the CocoaPods installation is available during this phase.

####Using RVM
If you installed CocoaPods on a RVM-managed Ruby, you need to make sure that `_teamsserver` has access to it.

If you're not using RVM, then you don't have to worry about this.

###The Script
Here's what you've been looking for.

```
# If you are using RVM, uncomment the `source` and `rvm use` lines.

# Load RVM
#source "$HOME/.rvm/scripts/rvm"

# Tell RVM to use the correct ruby version. Change to which version you are using
#rvm use ruby-1.9.3

cd ${SRCROOT}

pod install 
```
