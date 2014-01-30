---
layout: post
title:  "CocoaPods Search Design"
author: florian
categories: cocoapods search design
---

Just starting a search server and pumping some data into it is only going half
of the way towards a good search engine. To go all the way means adapting it to the
domain and needs of the users. I'll explain our rationale behind cocoapods.org along the way.

<!-- more -->

If you haven't yet seen [our search engine](http://cocoapods.org), please [give it a try](http://cocoapods.org) before reading this post.

This post is about designing a search engine for CocoaPods. I'm using [Picky](http://pickyrb.com) for it, with moderate modifications.

## The Story

<!-- Old site was mainly used for search -> Making the search central. -->

## Search Engine Design

<!-- Rewrite it all ;) -->

Chances are you know [RubyGems](http://rubygems.org). CocoaPods use a slightly different approach, one I personally find very elegant: After creating a [podspec](http://cocoapods.org/#get_started) (similar to a gemspec), you ask for it to be included in the [central repository](http://github.com/CocoaPods/Specs) via a pull request. If it is accepted, from then on you get commit rights to push other pods.

Since I think the [rubygems search](http://rubygems.org/search) is too slow, and not very impressive, I tried to make the [CocoaPods search](http://cocoapods.org) an example of how such a search should be designed. Try it! :)

(Note: I'm not just criticizing, but also _putting code where my mouth is_ regarding the rubygems search – try my slightly outdated [alternative take](http://gemsearch.heroku.com/) on it and [read about it here](http:///florianhanke.com/blog/2011/02/13/a-better-rubygems-search.html).

Many ideas for the CocoaPods search come from the old gem search alternative, but a few features are new, compiled in the…

### Highlights

* Automagic index updates via Github post receive hooks.
* Making composite names (e.g. BlocksKit) searchable by part (e.g. Blocks and Kit).
* Filtering by OS.
* Removing duplicates from results
* Fun things to try!

### Automagic index updates via Github post receive hooks

The challenge was to have Picky automatically update the search index without restarting, and without polling.

The fact that the CocoaPods specs live in their own repository is fantastic – it means that we have the full power of Github's repo features at our disposal.

The feature we use is [post receive hooks](http://help.github.com/post-receive-hooks/). Every time someone pushes a new spec, or updates a spec, the search engine sinatra app is notified via a garbled URL, as follows:

<pre><code>post "/my_example_hook_url/#{ENV['GARBLED_HOOK_PATH']}" do
  # index updating code here
end</code></pre>

Every time this URL is called, Picky downloads the zip file from github, unzips it, and indexes the loaded specs. All while running. That's it.

*HOLD ON!*, you say, why don't you just do a `git pull`? I wish I could. But currently, Heroku doesn't allow `git pull`,
or `tar`,
or `gunzip`. So currently, the search engine always downloads the zip file.

### Making composite names searchable

Pod names do not use spaces but are camelcased, e.g. "BlocksKit". Like most search engines, Picky would index this as one word.

Another issue with pod names is that authors sometimes prepend their initials to it. So, for example, "Mocky" would actually be called "LRMocky".

However, getting back to the "BlocksKit" example, we want people to be able to find it when they type [blocks kit](http://cocoapods.org/?q=blocks%20kit), or just [kit](http://cocoapods.org/?q=kit).

In Picky lingo: If the data contains `"BlocksKit"`, how do we index it as `"BlocksKit Blocks Kit"`?

Turns out there is a snazzy Ruby regexp for that:

<pre class="sh_ruby"><code>"BlocksKit".split /([A-Z]?[a-z]+)/ # => ["", "Blocks", "", "Kit"]</code></pre>

Nice, eh? As a bonus works fine with numbers :)

The Pod model offers a @prepared_name@ method, using the above @split@, returning @"BlocksKit Blocks Kit"@, which Picky uses for the @name@ category and consequently indexes all three words.

<pre class="sh_ruby"><code>category :name,
         similarity: Similarity::DoubleMetaphone.new(2),
         partial: Partial::Substring.new(from: 1),
         qualifiers: [:name, :pod],
         :from => :prepared_name # <= :from indicates which (data) method to call in the source object</code></pre>

Try it with "dynamic delegate":http://cocoapods.org/?q=dynamic%20delegate! :)

### Filtering by OS

Like Ruby gems, pods can run on multiple OSs: On iOS and/or on OS X.

We always want to filter by either both (AND), iOS, or OS X. This means we always prepend the platform filter to the query like so: `"on:some_platform rest of the query"`.

This is problematic since it uses a lot of input field space, and also confuses the user.

We would like to not show the OS in the search field, but use the value from the iOS style radio buttons.

Picky helps us by offering multiple JS callbacks. If you copy a search link like [http://cocoapods.org/?q=on:osx%20Kiwi](http://cocoapods.org/?q=on:osx%20Kiwi) into the URL bar, Picky
runs a few JS callbacks, in the following order:

* `beforeInsert(query) // Before inserting the query into the search field.`
* `before(query, params) // Before sending the query back to the server.`
* `after(data, query) // After receiving the query back, before rendering.`
* `success(data, query) // After the view/results have been updated.`

(`data` is the JS PickyData object)

We need both `beforeInsert` and `before`.

In `beforeInsert`, we remove the `os` part, before it is inserted into the search field. In `before`, before sending it to the backend, we add the OS back into the query, taken from the radio button value.

In code (the Picky JS search client options), it looks like this:

<pre class="sh_javascript"><code>// Before a query is inserted into the search field
// we clean it of any platform terms.
//
beforeInsert: function(query) {
  return query.replace(platformRemoverRegexp, '');
}</code></pre>

The regexp to remove the platform search term looks like this:

<pre class="sh_javascript"><code>var platformRemoverRegexp = /(platform|on\:\w+\s?)+/;</code></pre>

And before sending the search request to the backend, Picky calls the @before@ callback where we remove any OS parts, prepending the selected one (the iOS style radio buttons have the values @on:ios on:osx@, @on:ios@, and @on:osx@).

<pre class="sh_javascript"><code>before: function(query, params) {
  query = query.replace(platformRemoverRegexp, ''); // Clean the query.
  var platformModifier = platformSelect.find("input:checked").val(); // Get the selected OS.
  return platformModifier + ' ' + query; // Prepend it to the query.
}</code></pre>

However, the complete query, including the OS is still inserted into the URL, ready for you to copy and send to friends.

5 lines of nicely customizable code :)

### Removing duplicates from results

This is another more advanced Picky trick, which might only be interesting to pros.

I often get requests on how to remove duplicates from search requests.

Why are there duplicates in Picky's search results anyway?

Picky returns categorized search results. For example, it might deem the combination of categories @"first_name", "last_name"@ more important, before all search results found in the categories @"street", "last_name"@. But this also means that the same entry can be contained in both combinations of categories!

Many Picky users just use @results.ids@ to extract a list of ids. To get the list of ids, Picky goes through the results in each combination of categories and extracts the ids. This means that Picky may well return @[1,3,1,2,3]@,
with results @1@
and @3@ occurring twice.

Since cocoapods.org only wants to show an uncategorized list of result pods, we wish to remove duplicates to not confuse searchers.

We achieve this by using Picky's JS @success@ callback. This goes through all combinations of categories (aka _allocations_) and removes entries from the allocations if we've already seen them previously. It ensures we only see unique results.

<pre class="sh_javascript"><code>// We filter duplicate ids here.
// (Not in the server as it might be
// used for APIs etc.)
//
success: function(data, query) {
  var seen = {};
  
  var allocations = data.allocations;
  allocations.each(function(i, allocation) {
    var ids     = allocation.ids;
    var entries = allocation.entries;
    var remove = [];
    
    ids.each(function(j, id) {
      if (seen[id]) {
        data.total -= 1;
        remove.push(j);
      } else {
        seen[id] = true;
      }
    });
    
    for(var l = remove.length-1; 0 <= l; l--) {
      entries.splice(remove[l], 1);
    }
    
    allocation.entries = entries;
  });
  
  return data;
}</code></pre>

We could well do this in the server, but I opted against it, because a possible future search API might want to expose the duplicate results. This is why we do it in the client.

### Other fun things to try!

* [Search](http://cocoapods.org) for anything and then click on a pod author name in the results.
* Enter [Luke 1.0](http://cocoapods.org/?q=luke%201.0) to get all pods written by a luke with version 1.0*.
* Enter e.g. [stacked](http://cocoapods.org/?q=stacked) and press each platform button to see what happens to the results.
* Enter e.g. [uses:json](http://cocoapods.org/?q=uses:json) to see all pods which use a pod with "json" in their name.

h2. Feedback

We're very open for feedback – shoot us a line at [http://twitter.com/CocoaPods](http://twitter.com/CocoaPods) for comments on the cocoapods search, or at [http://twitter.com/picky_rb](http://twitter.com/picky_rb) for comments on the search engine itself. Thanks!

Thanks also to the CocoaPods team for a great project!