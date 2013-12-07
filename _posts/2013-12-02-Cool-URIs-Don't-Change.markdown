---
layout: post
title:  "Cool URIs don't change."
date:   2013-12-02
author: orta
categories: cocoapods website
---

TL;DR: _We broke some URIs but this is how we ensure people still get the info they were looking for._

To try and simplify where you can find CocoaPods documentation we deprecated [docs.cocoapods.org](http://docs.cocoapods.org) in favour of [guides.cocoapods.org](http://guides.cocoapods.org) and there will be further subsites with different focuses. To ensure a smooth transition I built a small sinatra app that might be of use to other people.

<!-- more -->

Whilst not entirely living up to the [W3C dream](http://www.w3.org/Provider/Style/URI.html) of the content changing but the URI not changing I felt a system of smart HTTP 302 permanent redirects would work quite elegantly for our system. Previously we had a static site that was held on github pages, this meant we had no ability to do true redirects, only HTMLs property `<meta http-equiv="refresh">`. This is a sledgehammer approach to redirects and we wanted to use a smaller tool. 

So I brought out ruby, the language CocoaPods is built in and created a small app using [sinatra](http://sinatrarb.com) that can be used to make a map of URLs to redirect to. Luckily there were not that many pages in the docs and we had equivilent pages in the guides. This is then turned into a [heroku](https://www.heroku.com) app and made to be the new [docs.cocoapods.org](http://docs.cocoapods.org) silently redirecting people to the new website with the same information they were looking for.

``` ruby
require 'sinatra'

NEW_URL = "http://guides.cocoapods.org"
ROUTES = {
  "/" => "/",
  
  # References
  "/podfile.html" => "/syntax/podfile.html",
  "/specification.html"=> "/syntax/podspec.html",
  "/commands.html"=> "/terminal/commands.html",
  
  # Guides
  "/guides/philosophy.html"=> "/using/faq.html",
  "/guides/installing_cocoapods.html" => "/using/getting-started.html",
  "/guides/dependency_versioning.html" => "/using/the-podfile.html",
  "/guides/closed_source_pods.html" => "/making/private-cocoapods.html",
  "/guides/working_with_teams.html" => "/making/private-cocoapods.html",
  "/guides/contributing_to_the_master_repo.html" => "/making/specs-and-specs-repo.html",
  "/guides/creating_and_maintaining_a_pod.html" => "/making/specs-and-specs-repo.html#how-do-i-update-an-existing-pod?",
  "/guides/creating_your_own_repository.html" => "/making/private-cocoapods.html",
  
  # Gem specifics should be handled by rubydoc 
  "/cocoapods/*" => "http://rubydoc.info/gems/cocoapods",
  "/cocoapods_core/*" => "http://rubydoc.info/gems/cocoapods-core",
  "/xcodeproj/*" => "http://rubydoc.info/gems/xcodeproj",
  "/claide/*" => "http://rubydoc.info/gems/claide",
  "/cocoapods_downloader/*" => "http://rubydoc.info/gems/cocoapods-downloader"
}

ROUTES.each_key do |key|

  # Create a sinatra route for each key, check if it's value starts with http
  # and either redirect to the new site with the same query.
  
   get key do
     if (ROUTES[key][0..3] == "http") 
       redirect ROUTES[key], 302
     else
       url = NEW_URL + ROUTES[key] + request.query_string
      redirect url, 302
     end
   end
 end 
 
 # If we've missed anything just go to the root of the new URL
 
 error Sinatra::NotFound do
   redirect NEW_URL + request.query_string
 end
 ```
 
 The repo can be found here [github.com/orta/CocoaPods-Docs-Redirector/](https://github.com/orta/CocoaPods-Docs-Redirector/)