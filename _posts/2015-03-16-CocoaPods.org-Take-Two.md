---
layout: post
title:  "CocoaPods.org Take Two"
author: orta
categories: cocoapods.org releases website
---

TL;DR: [CocoaPods.org][1] version 2 has been released, with support for inline deep search results, and pod pages.

<!-- more -->


## This took way longer than expected.

The CocoaPods web site is an interesting beast. In October 2013 we set around [rewriting][2] the CocoaPods web pages. We centralized the documentation, created a blog and redesigned everything. 

We settled on using a mix of middleman pages and jekyll. Given that, at the time, there was no central database for CocoaPods  it made sense to try and keep it as a static site for speed and maintainability.

Once [CocoaDocs v2][3] launched in May 2014, I set my sights on trying to move cocoapods.org a little bit closer to my larger vision of what the website would provide.

In an ideal world, you should be able to find a library that fits your constraints using just the front page of CocoaPods.org. Often there is more than one library, and that’s where the gets a bit more complex. In previous versions of the site, in order to choose between multiple libraries you need to open them up on github in separate tabs and compare. Now you don’t need to.

## Here’s how it works

Let’s take a random pod. [MiniFuture][4]. This is what happens after a Pod is released.

* A new Podspec version is added to [Trunk][5]
* A webhook from trunk gets sent to CocoaDocs triggering a documentation build
* The documentation build uses Jazzy ( or appledoc for Objective-C projects ) to generate documentation. 
* After documentation has finished we start generating metadata. This provides us with a rich dataset to start providing some useful statistics. This is centralized in [metrics.cocoapods.org][6] where we currently hold up-to-date github metrics also.

```json
// http://metrics.cocoapods.org/api/v1/pods/MiniFuture

{
	"cocoadocs": {
	    "created_at": "2015-03-08 16:48:25 UTC",
	    "doc_percent": 22,
	    "dominant_language": "Swift",
	    "download_size": 416,
	    "initial_commit_date": "2015-03-01 12:03:09 UTC",
	    "license_canonical_url": "http://opensource.org/licenses/MIT",
	    "license_short_name": "MIT",
	    "notability": 0,
	    "quality_estimate": 50,
	    "readme_complexity": 72,
	    "rendered_readme_url": "http://cocoadocs.org/docsets/MiniFuture/0.1.0/README.html",
	    "total_comments": 8,
	    "total_files": 4,
	    "total_lines_of_code": 327,
	    "total_test_expectations": 204,
	    "updated_at": "2015-03-08 16:48:25 UTC"
	},
	"github": {
	    "contributors": 1,
	    "created_at": "2015-03-01 10:09:08 UTC",
	    "forks": 0,
	    "language": "Swift",
	    "open_issues": 0,
	    "open_pull_requests": 0,
	    "stargazers": 8,
	    "subscribers": 2,
	    "updated_at": "2015-03-05 01:01:44 UTC"
	}
}
```
* A preview image is generated for the library for Social Media, chat, or really anything that supports open graph previews.
  {% breaking_image http://cocoadocs.org/docsets/MiniFuture/0.1.0/preview.png %}
  
* We then generate an estimated quality number for the library. This is based on a collection of [individual metrics][7] that are applied to the generated metrics data. They take a library and add or remove points based whether the rule applies for that library. These range from the popularity of the library, total test expectations / lines of code to the files and average lines of code per file in the library.

```json
// https://cocoadocs-api-cocoapods-org.herokuapp.com/pods/MiniFuture/stats

[
	{
	    "applies_for_pod": false,
	    "description": "Testing a library shows that the developers care about long term quality on a project as internalized logic is made explicit via testing.",
	    "modifier": -20,
	    "title": "Test Expectations / Line of Code"
	},
	{
	    "applies_for_pod": false,
	    "description": "Too big of a library can impact startup time, and add redundant assets.",
	    "modifier": -10,
	    "title": "Download size"
	},
	{
	    "applies_for_pod": false,
	    "description": "Smaller, more composeable classes tend to be easier to understand.",
	    "modifier": -8,
	    "title": "Lines of Code / File"
	},
	[...]
	{
	    "applies_for_pod": true,
	    "description": "A popular library means there can be a community to help improve and maintain a project.",
	    "modifier": 5,
	    "title": "Is popular"
	}
]
```

This gives enough metadata to start creating a page that represents the library with the kind of context that is specific to our community. In a lot of ways it can be better than the front page of the gitub repo because of this.

## How it comes together

We use the quality metrics in search, this is used to order the results we get back. There are quite a few different [sorting options](https://github.com/CocoaPods/search.cocoapods.org/blob/master/lib/search.rb#L345) now, so we may look into offering choices there.

We've started exposing a good chunk of the information in a pod's profile pages, and via inline results but not all of it. There's [interesting](https://github.com/CocoaPods/cocoapods.org/issues/107) [issues](https://github.com/CocoaPods/cocoapods.org/issues/106) around how we can expose more.

## Going forward

The APIs we use are all available for anyone to build things on top of. This data is pretty solid, the API routes won't be changing and work is on-going to make it more accurate. We'll only be expanding from here.

It's not perfect, but a website isn't an app and we can deploy daily. We re-wrote the homepage to run directly from the new databases and it's simplified the development process a lot. So it's easy for anyone to contribute and help out. We'll be iterating on it for a while before stablizing, so we'd love feedback in [an issue](https://github.com/CocoaPods/cocoapods.org/issues/new) or on twitter.

## It took a bunch of people too

Whilst I have been championing this feature for the last 8 months, I've had a lot of help:

* [Florian Hanke][8], [Sam Giddins][9], [Hugo Tunis][10] on metrics, search and a CocoaDocs API.
* [Kyle Fuller][11] on countless CocoaDocs improvements and maintainace
* [David Grandinetti][12], [Mike Lazer-Walker][13], [Phil Tang][14], [Brian Gesiak][15] and [Danny Hertz][16] on Quality/Popularity Metrics


[1]:	http://cocoapods.org
[2]:	http://blog.cocoapods.org/redesign/
[3]:	http://blog.cocoapods.org/CocoaDocs2-Launch/
[4]:	http://cocoapods.org/pods/MiniFuture
[5]:	http://blog.cocoapods.org/CocoaPods-Trunk/
[6]:	http://blog.cocoapods.org/metrics-api/
[7]:	https://github.com/CocoaPods/cocoadocs-api/blob/master/quality_modifiers.rb
[8]:	http://florianhanke.com
[9]:	http://segiddins.me
[10]:	%5Bhttp://www.hugotunius.se
[11]:	http://kylefuller.co.uk
[12]:	http://dbgrandi.github.io
[13]:	http://lazerwalker.com
[14]:	http://tang.io
[15]:	http://modocache.svbtle.com
[16]:	https://twitter.com/dannyhertz