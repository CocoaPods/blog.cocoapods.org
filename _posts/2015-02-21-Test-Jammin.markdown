---
layout: post
title:  "Test Jam"
post\_title\_id:  "testjam"
date:   2015-02-21
author: orta
categories: event virtual cocoapods tests 
---

Last year, around this time, we ran a [Bug Bash][1] over a weekend. It went beautifully. We triaged a whole lot of issues, got a lot of minor issues fixed and found some new members for the core team.

Not ones to repeat ourselves, we’ve begun preparations on the next big community event. It’s a test jam, and everyone is invited.

*TLDR/Elevator Pitch*: If the community is going to move towards Swift, then let’s make sure that our Objective-C is in order by adding tests to established libraries.

Find out more below.

<!-- more -->

Date: April 18th + 19th 2015
Locations: NYC / SF / + More

We have picked out 200 pods without tests, or with very low test coverage, ordered by [popularity][2]. These are assigned randomly to interested contributors. They then will aim to:

* Add tests to the library.
* Add [Travis CI][3].
* Add [Coveralls Support][4].
* Submit a Pull Request to the original repo.

We will be operating a chat room with a lot of high high profile names in Cocoa testing over the weekend offering advice. So if testing is new to you, it may be a perfect time to start.

Which tool each contributor chooses to write tests is up to the owner of a library. This isn’t about wrestling control from them, but supporting the project. They could prefer [XCTest][5], [Specta][6] / [Expecta][7] , [Kiwi][8] or [Cedar][9]. Each project will, ideally, have an issue stating this upfront. If not, it’s up to the contributor to decide.

We’re planning on emailing all authors soon offering the chance to opt-out or to advise on how to communicate a project’s testing intentions. 

Finally we’ll likely be having office space in [NYC (Artsy HQ)][10], SF and more (feel free to [email us][12] if you want to do one in your city.) So you can sit with fellow testers, discuss difficulties and share triumphs. 

🎉

[1]:	http://blog.cocoapods.org/CocoaPods-Bug-Bash/
[2]:	https://github.com/CocoaPods/search.cocoapods.org/blob/master/lib/models/pod.rb#L43-L56
[3]:	http://docs.travis-ci.com/user/languages/objective-c/
[4]:	https://coveralls.io
[5]:	http://www.objc.io/issue-15/xctest.html
[6]:	https://github.com/specta/specta
[7]:	https://github.com/specta/expecta
[8]:	https://github.com/kiwi-bdd/Kiwi
[9]:	https://github.com/pivotal/cedar
[10]:	https://foursquare.com/v/artsy/4f53d65de4b0b589399898a1
[12]:	mailto:info@cocoapods.org