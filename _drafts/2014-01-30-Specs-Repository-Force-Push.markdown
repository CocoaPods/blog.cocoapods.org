---
layout: post
title:  "Specs repository - Force Push"
date:   2014-01-30
author: kyle
categories: cocoapods
---

Unfortunately we've encountered a bug in libgit2 and we are going to have to
force push into the master specs repository.

### What does this mean for you?

Well, basically your CocoaPod's setup is going to break, you are going to have
to manually delete any local copies of the Spec's repository. You can do that
with the following command.

    $ pod repo remove master

_If you have any local commits or changes to the repository which are
not merged, you should ensure you have a copy of them. I would recommend that
you manually copy these changes over and re-commit them. You can fix your
repository without deleting however this is not a simple process, so we are
instead recommending that you delete your specs repository and any forks._

<!-- more -->

### Why did this break?

The Spec's repository has unfortunately broken due to a bug in libgit2 which
powers GitHub's web editor. This has caused our git repository to become
corrupt and the only solution is to rewrite the history of the repository and
force push. This will mean that any copies of the repository have to be deleted.

### Will this happen again?

There is a [fix](https://github.com/libgit2/libgit2/pull/2085) in the works
to fix the bug in libgit2. This fixes a bug which would prevent libgit2 from
corrupting a repository in this particular case.

GitHub are also working on putting checking measures in-place on the
web-editor so that it wouldn't be possible to save a corrupt repository, and to
prevent any similar problems in the future.

### Acknowledgements

I would like to personally thank the following people for their help in both
investigating and resolving this matter.

- Jeff King ([@peff](https://github.com/peff))
- Roberto Tyley ([@rtyley](https://github.com/rtyley))
- Abizer Nasir ([@Abizern](https://github.com/Abizern))

We're sorry for the inconvenience this may cause.

