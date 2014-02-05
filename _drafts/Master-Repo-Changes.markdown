---
layout: post
title:  "Master Repo Chances"
author: fabio
categories: master-repo
---

TL;DR: _The master repo will use the JSON format._

<!-- more -->

We plan to release CocoaPods 0.30 in date X. This version of CocoaPods will
support the new mechanism to push the specs to the master repo.

## Benefits

A podspec format not based on a DSL offers many advantages:

- No need to fork the master repo anymore to contribute.
- Access control list to the Pods.
- Easier programmatic generation and editing of podspecs
- Podspecs can be read on every platform.

## How the transition will be performed

For a (hopefully) small time-frame will not be possible to push specs anymore.

- Push access will be removed from the specs repo.
- The trunk app will go live.
- Release of CocoaPods 0.30.

Once CocoaPods is released you will be able to create an account with the `pod
trunk register` subcommand. [Note about the initial ACL creation]. You will be
able to add other owners with push privileges to a Pod with the `pod trunk
add-owner` subcommand.

Once a pod is released the only way to make a fix is to make a pull request in
the specs repo. So `pod push` will fail if a version for the pushed pod already
exists.

## Frequently Asked Questions

### How can I distinguish the format of a podspec.

Podspecs using the Ruby DSL will use the `.podspec` extension, JSON based
podspecs will use `.podspec.json`.

### Will the specs in the Ruby format be deprecated?

No. We plan to support them for the foreseeable future and `pod push` will take
care of converting them.

### Will private repos need to adopt the JSON format?

No. Moreover pod push will keep the old behaviour. Though if two files are
available CocoaPods will prefer the JSON format.

### Can I access the specs via http?

Yes you can use the following endpoints of the GitHub API.

To the get the list of the available Pods:

```
https://api.github.com/repos/CocoaPods/Specs/contents
```

To the get the available versions of a Pod:

```
https://api.github.com/repos/CocoaPods/Specs/contents/ObjectiveSugar
```

To fetch the podspec of a version of a Pod:

```
https://api.github.com/repos/CocoaPods/Specs/contents/ObjectiveSugar/0.9/ObjectiveSugar.podspec.json
```

