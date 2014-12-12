---
layout:     post
title:      "Search Engine"
date:       2014-12-12
author:     florian
categories: cocoapods search
---

TL;DR:
The [CocoaPods search engine](http://cocoapods.org) is not [web scale](http://www.mongodb-is-web-scale.com/). Here's why.

<!-- more -->

First let's look at some numbers...
Currently, the CocoaPods search engine indexes [7372 pods](http://metrics.cocoapods.org/api/v1/status).
From these pods, it indexes [name, author, version, dependencies, platform, summary, and synthesized tags](https://github.com/CocoaPods/search.cocoapods.org/blob/master/lib/search.rb#L70-L111).
On average, people search [13 times per minute](http://status.cocoapods.org/#custom-metrics-container).
The occasional spike is roughly ten times that, so about twice per second.
These spikes are not visible on the status page, as the number of requests are averaged over five minutes.

How do our users search?

## Searching on cocoapods.org

CocoaPods can be searched via the [Search API](http://blog.cocoapods.org/Search-API-Version-1/), so for example at [http://search.cocoapods.org/api/v1/pods.flat.hash.json?query=author:eloy](http://search.cocoapods.org/api/v1/pods.flat.hash.json?query=author:eloy), or via [cocoapods.org](cocoapods.org).

The latter, the web site front end is more interesting, so let's have a look at that.
The frontend on [cocoapods.org](cocoapods.org) has a few interesting features.
First, it is a fast search-as-you-type search – if you don't type for about 200 ms, it sends a query to the Search API.
The second feature I'd like to look at in more detail in the next section:
showing combinations of categories where a word was found.
A third feature lets you know when it hasn't found anything, but offers helpful suggestions, such as when you search for [datanotfound](http://cocoapods.org/?q=datanotfound).
Yet another feature sorts the results by [popularity](https://github.com/CocoaPods/search.cocoapods.org/blob/master/lib/models/pod.rb#L40-L44), a metric Orta came up with together with ?.
This is the default sorting algorithm right now, but we're [working](https://github.com/CocoaPods/search.cocoapods.org/issues/51#issuecomment-61655760) [on more](https://github.com/CocoaPods/search.cocoapods.org/issues/51#issuecomment-61655811). 
Other features include storing the query in the URL for easy copying, or a results addination (portmanteau of "adding" and "pagination"), or being able to select which platform the pods are filtered with.

With the search-as-you-type feature, we had an interesting issue:
it was well possible that a later request received an answer earlier than an earlier request.
This led to a jarring "jumping" of results.

To solve this issue, we only show results that arrive in the order we sent them.
If we send requests A, B, and C, and A returns first, we show it. If then C returns, we show it too, as it arrived in order.
If then B arrives after C, we discard it, as it is out of order.
That neatly solves the issue of jumping results, and also ensures a very responsive feeling for a user.

But what is the second feature about?

## Picky

[Picky](http://pickyrb.com/) is a [semantic text search engine](http://pickyrb.com/details.html), running on Ruby.
It is fast (it uses C for the core bits), flexible (it uses Ruby for maximum flexibility), and versatile.
On the other hand it does not yet offer a drop-in server, so if you need a web service, you need to write one, such as we did.
We use Picky for search.cocoapods.org.

Using Picky had two main impacts:
we were able to create a highly specialized search engine for pods, and we can harness the power of a semantic search engine.

So what is this semantic search you mention?
If you run [orta](http://cocoapods.org/?q=orta), in the top right corner you can see an "Author 5".
This means that Orta has been found five times as an author.
This may not be too exciting.

However, if you enter two words, or parts of words, then Picky can start guessing what you mean.
For example, if you enter [orta m](http://cocoapods.org/?q=orta%20m), then Picky guesses that you meant "Author+Name" (2 results) first, and "Author" (1 result) second.
The former refers to the two pods which are named "M*" and have Orta as an author.
The latter refers to the Mixpanel pod which has two authors:
Orta and Mixpanel (which is why the M* finds that one).

If you click [one of these suggestions](http://cocoapods.org/?q=author%3Aorta%20name%3Am*), then you can see that it's possible to let Picky know what you are looking for, if you already know ("author:orta name:m").
Normally you don't necessarily need it, but it can help if you have almost no idea anymore what the pod was called.
For example, perhaps you still remember that the author may have been Bob or Bert, so you enter a "B".
The pod almost certainly has a word with a c in it, so you add a "C".
Then Picky will show you all possibilities that a query like "B* C" results in.
[This query](http://cocoapods.org/?q=author%3Ab*%20name%3Ac) is the resulting one.

And how is it specialized for pods?
For example, when indexing pod names, we give the search engine the pieces we expect will be queried for.
That usually means e.g. for ["TICoreDataSync"](http://cocoapods.org/?q=ticoredatasync), we [split it into the two uppercase initials, and each word starting with an uppercase letter, and also the whole word without the two initials](https://github.com/CocoaPods/search.cocoapods.org/blob/master/lib/models/pod.rb#L224-L239).
This enables you to search for ["coredata"](http://cocoapods.org/?q=coredata) and get the above pod.
Or you can search for ["network"](http://cocoapods.org/?q=network), and get AFNetworking.

## Limitations

As the CocoaPods team cannot afford a server farm, but only a single server on Heroku, and a cheap shared CPU at that, we needed to be smart in designing the infrastructure.
We started with a list of requirements:

* It should fit and work on a shared Heroku CPU.
* It should be reindex pods using Trunk web hook calls. So if a pod is pushed to Trunk, search should know about it ASAP (in less than 30 seconds).
* It should be stable. Nobody likes not being able to search.
* It should have little downtime when restarting.

## Design

## Summary and The Future

To make a truly pod-specific search engine that would enable us to experiment and at the same time fit on a single shared Heroku instance, we used [Picky](http://pickyrb.com/) and a multiprocessing-based structure, while still being able to serve enough results at a time.

We are currently [working towards a CocoaPods search interface version 2](https://github.com/CocoaPods/search.cocoapods.org/issues/51) that will hopefully blow your minds.
It will be the culmination of hours of volunteer work and will pull together data from our many APIs.

Please leave your ideas, if you have something to add.