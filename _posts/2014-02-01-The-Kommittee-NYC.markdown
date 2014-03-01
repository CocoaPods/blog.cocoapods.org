---
layout: post
title:  "Cocoa Komittee - NYC"
author: orta
categories: meetup komittee nyc
---

One should avoid repeating oneself. New York City is where we started running [Cocoa Kuchas](http://blog.cocoapods.org/Cocoa-Kucha/) last year and whilst there's a lot more stories to tell here it's time to move on.

This month we will be hosting a panel on iOS Testing. Find out more inside.

<!-- more -->

The Komittee is an event where we will take people with strong opinions, and get them started on a contentious topic and see if we can learn something from the process. Testing in general is a hot topic. Mix that with a tight platform, closed tools and you've got a lot of flames.

## Details

We are graciously being hosted by Spotify, at their [NYC HQ](https://www.google.com/maps/preview/place/Spotify+USA/@40.7420096,-74.0000379,16z/data=!4m5!1m2!2m1!1sSpotify+USA,+West+18th+Street,+New+York,+NY!3m1!1s0x0:0x8dc308c2ad65f154) on the 25th of February at 7pm.

## Topics

* QA vs Automated Unit testing
* Testing units of code vs Testing behavior
* Obj-C implementation strategies vs other ecosystems
* Time management
* Ways to improve testing for everyone

## The Panel


<ul class='people'>
{% include person.html name="db" github="dblock" twitter="dblockdotorg" %}
{% include person.html name="Benjamin Jackson" github="benjaminjackson" twitter="benjaminjackson" %}
{% include person.html name="Make Lazer-Walker" github="lazerwalker" twitter="lazerwalker" %}
{% include person.html name="Klaas Pieter" github="klaaspieter" twitter="klaaspieter" %}
{% include person.html name="Paul Young" github="paulyoung" twitter="py" %}
{% include person.html name="Brian Gerstle" github="btgerst" twitter="b_gerstle" %}
{% include person.html name="Landon J Fuller" github="landonf" twitter="landonfuller" %}
</ul>


## Meetup Page

[Here](http://www.meetup.com/CocoaPods-NYC/events/164278492/)

## Show notes


<style>
.notes ul p {
  margin:8px;
}
</style>
<div class = "notes">

  <h4>Landon Fuller</h4>
  <ul>
    <li>
      <h4>Unit Testing</h4>
      <p>OCUnit for projects supporting <= iOS 6, and <= Mac OS X 10.7</p>
      <p>XCTest for projects supporting >= iOS 7, >= Mac OS X 10.8</p>
    </li>
    <li>
      <h4>Continual Integration</h4>
      <p>Jenkins: http://jenkins-ci.org/</p>
      <p>Confluence: https://www.atlassian.com/software/bamboo/</p>
    </li>
  </ul>

  <h4>Paul Young</h4>
  <ul>
    <li>
    <h4>Frameworks</h4>
      <p>Specta</p>
      <p>Expecta - https://github.com/specta/expecta</p>
    </li>
    <li>
      <h4>OCMockito - https://github.com/jonreid/OCMockito</h4>
      <p>I used to use OCMock but had hang ups because:</p>
      <p>It reports test failures by raising exceptions (not useful enough, weird output, can’t click and go to the test failure). Klaas mentions this in <a href="http://www.annema.me/why-i-prefer-testing-with-specta-expecta-and-ocmockito">his article linked</a>.</p>
      <p>Expectations aren’t cleared when you call `stopMocking` which means you can’t use a setup step/beforeEach block to make your spec DRY.
  “Partial" mocks allowed me to mock part of the subject under test which seems wrong. OCMockito doesn’t allow this.</p>
    </li>
    <li>
      <h4>Tools</h4>
      <p>Rake  - a la AFNetworking https://github.com/AFNetworking/AFNetworking/blob/master/Rakefile </p>
      <p>XCTool - although having an issue currently: https://github.com/facebook/xctool/issues/314 </p>
      <p>Travis - followed this article: http://www.objc.io/issue-6/travis-ci.html but there were a few gotchas:</p>
      <p>Travis devs forgot to add CocoaPods to the VM so you have to install the gem in your before_script phase. It works but makes the build take a lot longer. You can make it quicker by not installing the docs for the gem. https://github.com/travis-ci/travis-ci/issues/1657 </p>
      <p>Travis devs forgot to set some of the environment variables: https://github.com/travis-ci/travis-ci/issues/1769 </p>
      <p<There’s no Mavericks VM yet. See AFNetworking Rakefile for a workaround. https://github.com/travis-ci/travis-ci/issues/1851 </p>
      <p>Hockey - http://hockeyapp.net/features/ - The apps are pretty good: http://hockeyapp.net/apps/ </p>

      <p>I followed the objc.io article to push from Travis to Hockey on a successful build in master. Thinking about seeing if Shenzhen (https://github.com/nomad/shenzhen) by Matt Thompson is a better long term solution.</p>
  </ul>

  <h4>Klaas Pieter Annema</h4>
  <p>I use Specta, Expecta and OCMockito. I've also been using Barista for integration tests. Everything is automatically run on Travis. Tools I use: Cocoapods, Bundler (so I can have a specific Cocoapoads version per project), Rake and xctool.</p>
</div>
