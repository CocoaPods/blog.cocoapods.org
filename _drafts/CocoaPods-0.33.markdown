---
layout: post
title:  "CocoaPods 0.33"
date:   2014-05-20
author: fabio
categories: cocoapods releases
---

TL;DR: _CocoaPod 0.33 has been released. It is shiny and brings a huge change
for our community… the support for CocoaPods trunk._

<!-- more -->



## New command line UI

Features:

- Colors for subcommands, options, and arguments
- More consistent documentation for optional arguments
- alignment of the descriptions
- Wrapping of the description to the terminal width with a maximum width considered

<center><a href="http://feeds.cocoapods.org">
{% breaking_image /assets/blog_img/CocoaPods-0.33/pod_help.png %}
{% breaking_image /assets/blog_img/CocoaPods-0.33/pod_install_help.png %}
</a></center>

There is still some debate about how to handle white backgrounds. So if you
have an option share your view on [our empty TODO](https://github.com/CocoaPods/CocoaPods/issues/2159)

<center><a href="http://feeds.cocoapods.org">
{% breaking_image /assets/blog_img/CocoaPods-0.33/pod_help_white.png %}
</a></center>


## Support for completions scripts

A new root option ` --completion-script` has been implemented which generates
the completion script. It takes into account the installed plugins.

Currently only ZSH is supported.

```
rm -f /usr/local/share/zsh/site-functions/_pod
pod --completion-script > /usr/local/share/zsh/site-functions/_pod
exec zsh
```

<center><a href="http://feeds.cocoapods.org">
{% breaking_image /assets/blog_img/CocoaPods-0.33/pod_search_completion.gif %}
</a></center>


## cocoapods-trunk

CocoaPods trunk is the new way to push to the master repo. You can read more
about it in the dedicated [blog post](TODO). For CocoaPods users it is relevant
to know that since the `pod push` command is intended for private repos it has
been moved to `pod repo push` (a temporary alias has been provided). Moreover
the `pod repo push` command will abort if there is an attempt to push to a repo
pointing to the master repo as the remote.

During the development of trunk we discovered that some users are not properly
leveraging private repos:

  * If you are using the master repo to add your own private specs, don’t do this.
  * If you are using the name ‘master’ for you own private spec-repo, don’t do this.

Things will break.

## cocoapods-plugins

[David Grandinetti](https://github.com/dbgrandi) and [Olivier
Halligon](https://github.com/AliSoftware) have been hard at work to tame the
proliferation of plugins. With the extremely meta `cocoapods-plugins` plugin you
can now list, search and check the available versions of the CocoaPods plugins.
Moreover, [Boris Bügling](https://github.com/neonichu) created a template (`pod
plugins create`) so gettng started has never been easier.

A great example of a new CocoaPods plugin is [podroulette](http://podroulette.com).


## Updating

To install the last release of CocoaPods you can run:

```
$ [sudo] gem install cocoapods
```

Until version 1.0 we strongly encourage you to keep CocoaPods up-to-date.

For all the details, don’t miss the
[Changelog](https://github.com/CocoaPods/CocoaPods/blob/master/CHANGELOG.md).
