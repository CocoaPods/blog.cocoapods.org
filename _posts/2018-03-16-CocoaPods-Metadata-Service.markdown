---
layout: post
title:  "New Service: CocoaPods Metadata generation"
author: orta
categories: cocoadocs documentation cocoapods.org
---

This week we shipped a new behind-the-scenes service for CocoaPods authors: [cocoapods-metadata-service][cms] it handles
a subset of CocoaDocs responsibilities but does not have the requirement of running on a Mac. This makes it easier for
us to maintain.

It's been almost a year since [we announced that CocoaDocs][cd_down] was going to be shut down. CocoaDocs' sunsetting
was intially slowed down by the team at [BuddyBuild][bb] offering to take over the project, but the migration wasn't
finished before they were [acquired by Apple][appl]. This means they cannot take over community services.

Instead I've started building out a simpler replacement that handles just the needs of the cocoapods.org website. Read
on to find out what that looks like.

<!-- more -->

### Why build this?

CocoaPods' web infrastructure needs to continue to be hardened. We have fewer contributors and a lot more people using
CocoaPods. Moving more of our web services into heroku means we have less diversity in how projects are hosted get run.
Hosting a Mac Mini on the internet is a lot of work, and I wouldn't wish it on anyone else.

There's a tricky thing here though. CocoaDocs would run through the full `pod install` process and use the files to
generate a set of useful metrics for each pod:

```sh
install_size
total_files
total_comments
total_lines_of_code
doc_percent
readme_complexity
initial_commit_date
rendered_readme_url
license_short_name
license_canonical_url
total_test_expectations
dominant_language
builds_independently
is_vendored_framework
rendered_changelog_url
rendered_summary
spm_support
```

Not all of these attributes are feasible when running on heroku because it has an [ephemeral filesystem][eth]. For
example a repo would include example projects and code which are removed by the `pod install` - CocoaDocs would then use
the remaining files to generate details on. In order to work on host without a local clone of the pod, some of those
metrics need to be optional.

I built this service to focus on the most pressing problem first: READMEs, CHANGELOGs and license information.
Basically:

```sh
rendered_readme_url
license_short_name
license_canonical_url
rendered_changelog_url
```

Some of the other attributes can be added later, for example I see no blockers on adding `dominant_language`,
`is_vendored_framework`, `initial_commit_date`, `spm_support` and `readme_complexity` to the service, but some
attributes are just not going to be feasible.

This service has so far focused exclusively on Open Source GitHub projects, with plans to expand to Pods that use
[.tar.gz][tar] and [zip][zip] files coming soon.

It's the first JavaScript project (TypeScript) in the CocoaPods org, because once I worked with TypeScript I couldn't go
back to Ruby for a new project. This does introduce some complexity though. So I opted to livecode the entire process of
building the v1 and getting the project into production.

This means if you're interested in how to build a small NodeJS server in TypeScript, you've got a small well-built
example with [a YouTube playlist of over 5 hours][yt] where I have to explain all of my choices.

<center>
<iframe width="560" height="315" src="https://www.youtube-nocookie.com/embed/videoseries?list=PLYUbsZda9oHs-MoWKiZNXtvGK9ye8nZZe" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>
</center>

As we rely more on this service, we can continue to provide the rich web-experience with far less dependencies on hard
to maintain infrastructure, which paves the way for CocoaPods to continue being a useful resource for a very long time.

[cms]: https://github.com/CocoaPods/cocoapods-metadata-service
[cd_down]: {% post_url 2017-03-28-CocoaDocs-Documentation-Sunsetting %}
[bb]: http://buddybuild.com
[appl]: https://www.buddybuild.com/blog/buddybuild-is-now-part-of-apple
[eth]: https://devcenter.heroku.com/articles/dynos#ephemeral-filesystem
[yt]: https://www.youtube.com/watch?v=KpX0jRDEv14&list=PLYUbsZda9oHs-MoWKiZNXtvGK9ye8nZZe
[tar]: https://github.com/CocoaPods/cocoapods-metadata-service/issues/2
[zip]: https://github.com/CocoaPods/cocoapods-metadata-service/issues/1
