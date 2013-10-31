---
layout: post
title:  "Using Acknowledgements"
date:   2013-08-10
author: fabio
categories: ios xcode 
---

CocoaPods will generate two 'Acknowledgements' files for each target specified in your Podfile. If the pods are coming from the master repo, then they must include one. Private pods don't require one. These contain the License details for each Pod and for most of the part having them in your acknowledgements will be enough to conform to the license.

CocoaPods generates a markdown file for general consumption, as well as a property list file that can be added to a settings bundle for an iOS application. You don't need to do anything for this to happen, it will just work. If you'd like to know more about extra things you can do with this, read on.

<!-- more -->

## Customization

If you're not happy with the default boilerplate text generated for the title, header
and footnotes in the files, it's possible to customise these by overriding the methods
that generate the text in your `Podfile` like this:

``` ruby
class ::Pod::Generator::Acknowledgements
  def header_text
    "My custom header text"
  end
end
```

You can even go one step further and customise the text on a per target basis by checking against the target name, like this:

``` ruby
class ::Pod::Generator::Acknowledgements
  def header_text
    if @target_definition.label.end_with?("MyTargetName")
      "Custom header text for MyTargetName"
    else
      "Custom header text for other targets"
    end
  end
end
```

These are the available methods to override: `header_title`, `header_text`, `footnote_title` & `footnote_text`.

## iOS Settings Bundle

If you are using the generated `plist` in your settings bundle you might want to update the file every time that you update your pods. This can be accomplished by adding to your `Podfile` the following `post_install` hook.

``` ruby
post_install do | installer |
  require 'fileutils'
  FileUtils.cp_r('Pods/Pods-Acknowledgements.plist', 'Resources/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end
```

To access this from your Setting Bundle's Root.plist replace your Root.plist with this:

``` xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>StringsTable</key>
	<string>Root</string>
	<key>PreferenceSpecifiers</key>
	<array>
		<dict>
			<key>Type</key>
			<string>PSChildPaneSpecifier</string>
			<key>Title</key>
			<string>Acknowledgements</string>
			<key>File</key>
			<string>Acknowledgements</string>
		</dict>
	</array>
</dict>
</plist>
```

Further details can be found in [Martin Hicks's blog](http://martinhicks.net/2012/04/how-to-create-license-section-in-ios-settings-app)