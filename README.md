# blog.cocoapods.org

The blog for CocoaPods

## Setup

To install git submodules and grab ruby dependencies:

```
$ rake bootstrap
```

## Development

To start a local server that shows all posts **including** drafts:

```
$ rake serve:drafts
```

_This is also the default task, so just `rake` will do the same._

----

Or if you want to see the blog **without* any draft posts, as the blog would
look if it were to be deployed right now:

```
$ rake serve:published
```

----

The `shared` submodule is the cocoapods [shared
resources](https://github.com/CocoaPods/shared_resources) repo that holds
shared design notes and assets.

## Add a new author

Navigate to the _config.yml file.
Add a nickname for you followed by your full name, twitter handle and gravatar hash.

## Add a new post

Create a new file in _post directory following the format year-month-day-blog-post-title.markdown

Start the post using Jekylls [Front Matter](http://jekyllrb.com/docs/frontmatter/):

```
---
layout: post
title:  "Blog Post Title"
author: nickname
categories: tags that are relevant
---
```

## Deployment

Run `rake deploy` to push to site the gh-pages branch.

The `_gh-pages` folder (which is ignored) is used to checkout the gh-pages of
this repo. `rake deploy` will push the built version of the site to that branch
and push to the server pulling in any changes.

## Drafts

Drafts are stored in the `_drafts` folder to leverage the [drafts feature] of
jekyll. The `rake serve` task is configured to show the drafts.

[drafts feature]: http://jekyllrb.com/docs/drafts/


## License

This repository and CocoaPods are available under the MIT license.
