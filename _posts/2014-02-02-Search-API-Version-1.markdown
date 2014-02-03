---
layout: post
title:  "Search API Version 1"
author: florian
categories: search api
---

I'm going to break up the doom & gloom around the [Specs Repo change](/Repairing-Our-Broken-Specs-Repository/) with some good news. We have opened up v1 of our search API!

This is the API used in [CocoaPods.org](http://cocoapods.org) and soon on [CocoaDocs](http://cocoadocs.org). Read on to find out how to use it in your own applications, I'm really excited to see what people do with it.

<!-- more -->

## API Description

### Pods Endpoint

```
http://search.cocoapods.org/api/pods
```

### Query String Parameters

```
query:    The query string.
amount:   The number of results requested [Default: 20].
start-at: The offset in the set of results [Default: 0].
```

#### Example

```
http://search.cocoapods.org/api/pods?query=test&amount=100&start-at=50
```

#### What query string do I use?

The `query` string you use is what you type into the search engine on [CocoaPods.org](http://cocoapods.org). In addition, you can filter on either or both platforms by prefixing the query string with `on:ios`, `on:osx`, or `on:ios on:osx` (we hide this behind the four radio buttons).

For example, if you'd like to only see "test" pods that run on iOS then you prefix the query string with `on:ios`:

```bash
curl 'http://search.cocoapods.org/api/pods?query=on:ios%20test'
```

### Formats

We return 4 different formats, all in JSON:

1. [Picky-style results](https://github.com/floere/picky/wiki/results-format-and-structure) with pod data as hashes.
1. [Picky-style results](https://github.com/floere/picky/wiki/results-format-and-structure) of pod names as string.
1. Flat list of results with pod data as hashes.
1. Flat list of results of pod names as string.

What format you'd like you need to provide via the Accept header. The 4 options above translate into:

```
Accept: application/vnd.cocoapods.org+picky.hash.json; version=1
Accept: application/vnd.cocoapods.org+picky.ids.json; version=1
Accept: application/vnd.cocoapods.org+flat.hash.json; version=1
Accept: application/vnd.cocoapods.org+flat.ids.json; version=1
```

#### Defaults

You don't have to provide all the details. For example, providing no version will return the latest version. We recommend that you always provide the version nonetheless.

See a list of [all specs](https://github.com/CocoaPods/search.cocoapods.org/blob/8908eaaf83a11b3075d36032cb8c5896e37c7366/spec/api/accept_integration_spec.rb#L23-L59). All of these parameters will return a result.

The default format is Picky-style results with pod information as a hash.

### Examples

#### Formats

```bash
curl 'http://search.cocoapods.org/api/pods?query=name:kiwi' \
  -H "Accept: application/vnd.cocoapods.org+picky.hash.json; version=1"

curl 'http://search.cocoapods.org/api/pods?query=name:kiwi' \
  -H "Accept: application/vnd.cocoapods.org+picky.ids.json; version=1"

curl 'http://search.cocoapods.org/api/pods?query=name:kiwi' \
  -H "Accept: application/vnd.cocoapods.org+flat.hash.json; version=1"

curl 'http://search.cocoapods.org/api/pods?query=name:kiwi' \
  -H "Accept: application/vnd.cocoapods.org+flat.ids.json; version=1"
```

#### Query Params

```bash
curl 'http://search.cocoapods.org/api/pods?query=name:test' \
  -H "Accept: application/vnd.cocoapods.org+flat.ids.json"

curl 'http://search.cocoapods.org/api/pods?query=name:test&start-at=3' \
  -H "Accept: application/vnd.cocoapods.org+flat.ids.json"

curl 'http://search.cocoapods.org/api/pods?query=s&amount=1000' \
  -H "Accept: application/vnd.cocoapods.org+flat.ids.json"
```

### Convenience Endpoints

It's not always convenient to use curl on the command line and type the Accept header. So we also offer 4 further endpoints, for quick result viewing in a browser.

```
http://search.cocoapods.org/api/v1/pods.picky.hash.json?query=test
http://search.cocoapods.org/api/v1/pods.picky.ids.json?query=test
http://search.cocoapods.org/api/v1/pods.flat.hash.json?query=test
http://search.cocoapods.org/api/v1/pods.flat.ids.json?query=test
```

## Caveats

As we improve the search engine, it might be down for half a minute at a time, sporadically. Please allow for this eventuality in any user interfaces.

Have fun with it - we are curious what you all are coming up with! Personally, I'd love a CocoaPod that parsed [Picky-style results](https://github.com/floere/picky/wiki/results-format-and-structure) and provided it to other applications <3