---
layout:     post
title:      "Metrics API"
date:       2014-12-11
author:     florian
categories: metrics api
---

TL;DR:
We have a new _metrics_ API that you can now use.

<!-- more -->

For the past nine months, we've had a metrics API where we gather data for each pod, currently only from GitHub.

## API

Currently the API provides GitHub metrics, per pod.
The provided format is JSON, which is also the default.

It's best if you give it a try yourself.
Here's a popular pod:
[http://metrics.cocoapods.org/api/v1/pods/AFNetworking.json](http://metrics.cocoapods.org/api/v1/pods/AFNetworking.json)

And here's a not yet popular pod:
[http://metrics.cocoapods.org/api/v1/pods/KFData.json](http://metrics.cocoapods.org/api/v1/pods/KFData.json)

The API pattern is, you guessed it:
[http://metrics.cocoapods.org/api/v1/pods/PODNAME.json](http://metrics.cocoapods.org/api/v1/pods/PODNAME.json)

Each pod's data is updated roughly every 2 hours.

To check the status of the metrics app, you can call:
[http://metrics.cocoapods.org/api/v1/status](http://metrics.cocoapods.org/api/v1/status)

This will tell you the total amount of pods, and how many have been found on GitHub, and how many have not been found after three tries.

## Design

The metrics app is very straightforward.
It lives on Heroku and consists of two pieces:
A round robin updater, and a resetter.

The updater is forked off as the web app is started.
It runs forever and goes through each pod, one by one.
Every second, it queries GitHub for metrics data of another pod.
Currently, all pods are updated roughly every two hours.

If it can't find the pod, it marks the pod as once not found.
If your pod is not found three times (on GitHub), roughly 6 hours, it gives up on the pod.
Currently there are 117 pods which have no corresponding repo page on GitHub.
This is ok, as not everybody is or needs to be on GitHub.

If a pod is not found, won't metrics ever try again?
We've got that covered.
The resetter listens to the Trunk (where you push pods) web hooks.
The trunk web hook system pings many CocoaPods websites to inform them of updated pods.
If a new pod has been added, just a new versions, or a new commits – it pings for example the metrics webapp.
If the metrics app receives the Trunk app's bat signal, it resets the pod's not found count.
From then on, metrics will try to find the pod's metrics again on GitHub.

## Closing words

Why use this instead of the GitHub API?
You can access it via a pod's name and it's designed to be extensible, so more exciting metrics will be added.

We hope you'll use the API for success and profit.
If you do, let us know.

Also, if you feel strongly that another service (besides GitHub) should be included, let us know.

Go forth and measure!