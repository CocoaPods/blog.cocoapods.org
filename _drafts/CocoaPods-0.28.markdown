---
layout: post
title:  "CocoaPods 0.28"
date:   2013-11-08
author: fabio
categories: cocoapods releases
---

TL;DR: _CocoaPods 0.28 introduces support for plugins and numerous bug fixes._

Support for third party plugins has been introduced in CocoaPods. Plugins will
are able to additional commands to CocoaPods. This sweet feature has been
contributed by [Les Hill].

[Les Hill]: http://blog.leshill.org

<!-- more -->

Two plugins are available [cocoapods-open] and the [cocoapods-docs].

[cocoapods-open]: https://github.com/leshill/open_pod_bay
[cocoapods-docs]: https://github.com/CocoaPods/cocoapods-docs

We recommend plugin authors to namemespace their gems with the
`cocoapods-PLUGIN_NAME` prefix.  In this way it is easy to look for CocoaPods
plugins using this [RubyGems search].

[RubyGems search]: http://rubygems.org/search?utf8=✓&query=cocoapods-

Other relevant changes in this release are related to bug fixes to the support
for the `xcassets` resources.


## Creating plugins

Any installed gems with a file named `cocoapods_plugin.rb` will be loaded
via that file. Convention is to require the actual command implementation in
the plugin file.

For example [cocoapods-open] has the following `lib/cocoapods_plugin.rb`

```ruby
require 'pod/command/open'
```

### Adding subcommands

To add a new command you can create a subclass of the command which will be 
used a as a namespaced. Then you can provide some meta data about the command
and add your custom logic:

```ruby
module Pod
  class Command
    class Spec
      class Doc < Spec
        self.summary = "Opens the web documentation of a Pod."

        self.description = <<-DESC
          Opens the web documentation of the Pod with the given NAME.
        DESC

        self.arguments = 'NAME'

        def initialize(argv)
          @name = argv.shift_argument
          super
        end

        def validate!
          super
          help! "A Pod name is required." unless @name
        end

        def run
          path = get_path_of_spec(@name)
          spec = Specification.from_file(path)
          UI.puts "Opening #{spec.name} documentation"
          `open "http://cocoadocs.org/docsets/#{spec.name}"`
        end
      end
    end
  end
end
```

### Hooking to the installation

As of yet there are no promises made yet on the APIs, so try to fail as
gracefully as possible in case a CocoaPods update breaks your usage. In these
cases, also please let us know what you would need, so we can take this into
account when we do finalize APIs.


## Updating

To install the last release of CocoaPods you can run:

```
$ [sudo] gem install cocoapods
```

Until version 1.0 we strongly encourage you to keep CocoaPods up to date.

For all the details, don't miss the
[Changelog](https://github.com/CocoaPods/CocoaPods/blob/master/CHANGELOG.md).

