---
layout: post
title:  "Master spec-repo rate limiting post&#x2011;mortem"
author: eloy
categories: cocoapods
---

[Recently](https://github.com/CocoaPods/CocoaPods/issues/4989) we were made aware of issues that our users had when
cloning the [CocoaPods Master spec-repo](https://github.com/CocoaPods/Specs), which contains specifications for projects
shared _by_ and _with_ the community.
[The GitHub infrastructure team](https://github.com/CocoaPods/CocoaPods/issues/4989#issuecomment-193772935) were quick
to explain that this was because of us hitting CPU rate limits on their end, which turned out to be caused, besides the
high volume of clones, by the default options we chose to clone this repo.

<!-- more -->

After
[some](https://github.com/CocoaPods/CocoaPods/issues/4989#issuecomment-193772935)
[back](https://github.com/CocoaPods/CocoaPods/issues/4989#issuecomment-193810378)
[and](https://github.com/CocoaPods/CocoaPods/issues/4989#issuecomment-193835710)
[forth](https://github.com/CocoaPods/CocoaPods/issues/4989#issuecomment-193838934),
[we](https://github.com/CocoaPods/CocoaPods/issues/4989#issuecomment-193869281)
[settled](https://github.com/CocoaPods/CocoaPods/issues/4989#issuecomment-193875012)
on the following list of causes and solutions.

### Shallow clone

To ease initial setup for CocoaPods users, we performed shallow clones of spec-repos, meaning they only had to fetch the
latest state of the repo. However, this meant that the GitHub servers had to spend much more time figuring out which Git
objects the user already has, needs, and compute the deltas for those objects.

Therefore, we are no longer going to shallow clone spec-repos on initial setup and we’ll automatically convert existing
shallow clones to full clones.

### Too many fetches

To ensure the user always has access to all the available podspecs, we automatically performed a `git fetch` on each
`pod install` and `pod update`. The amount of fetches this resulted in made the above shallow clone issue even worse.
That, combined with the fact that on most `pod install` runs there was little need to actually update the repo, led to
us changing the following:

- We will no longer automatically update spec-repos on `pod install`. If a lockfile exists and podspecs are missing, an
  error will be raised that suggests the user to update their spec-repos with `pod repo update`.

- We will still automatically update the spec-repos on `pod update`, because that’s implicitly what the user asks for at
  that time, but it’s an action taken far less often than running `pod install`.

- Before _any_ Master spec-repo fetching, we’ll be making use of a GitHub API that returns if a repo has changes in a
  far more efficient manner. [This API](https://developer.github.com/changes/2016-02-24-commit-reference-sha-api) is
  also used by Homebrew for this very same reason.

### Too many directory entries

In the Git object model, each change to a directory results in a new ‘tree’ object and many Git operations need to
traverse this tree, which internally has to be recreated through multiple steps of deltas, each of which has to be found
and decompressed. Currently, spec-repos have a flat structure where all pod directories are in the same `Specs`
directory, which at the time of writing has ~16K entries and consists of ~100K commits. Suffice to say, these are a lot
of very large tree objects and thus require a lot of computation.

To fix this, [we’ll shard](https://github.com/CocoaPods/cocoapods-repo-shard) the `Specs` directory of a spec-repo by
hashing the pod names and create sub-directories based on the first few characters of that hash, so that there will be
far less entries in any given sub-directory.

This will make file-system level browsing of a spec-repo less intuitive, but a solution like this was required to deal
with 1 character pod names _including_ single emoji characters. Note, though, that we have
[tooling](https://guides.cocoapods.org/terminal/commands.html#group_specifications) that eases this, such as the
`pod spec which` command.

## Roll-out

Except for the solution to the third issue, these changes are already available since version 1.0.0.beta.6. While we
already have the code in place to shard the spec-repo, activating it now would require updating the existing spec-repo
and forcing < 1.0.0.beta.7 users to upgrade now, which might be a hard situation for people that need time to deal with
breaking version 1.0.0 changes. We’ll be activating it not long after version 1.0.0 has been released, though, so don’t
wait too long with upgrading.

## Unable to upgrade just yet?

If for whatever reason you cannot upgrade to version 1.0.0 just yet, you can perform the following steps to convert your
clone of the Master spec-repo from a shallow to a full clone:

    $ cd ~/.cocoapods/repos/master
    $ git fetch --unshallow

## Thanks

We would like to thank [@mhagger](https://github.com/mhagger), [@vmg](https://github.com/vmg), and
[@mikemcquaid](https://github.com/mikemcquaid) for helping diagnose the issues and our understanding thereof;
[@arthurnn](https://github.com/arthurnn) for his help with optimizing the way sharding should work, as well as GitHub in
general for their continued generous sponsorship of hosting resources.

In addition we would like to thank [@segiddins](https://github.com/segiddins),
[@DanielTomlinson](https://github.com/DanielTomlinson), and [@mrackwitz](https://github.com/mrackwitz), for their hard
work on implementing these solutions as soon as they did.

