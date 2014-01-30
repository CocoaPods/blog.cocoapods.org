---
layout: post
title:  "Specs repository - Force Push"
date:   2014-01-30
author: kyle
categories: cocoapods
---

Unfortunately we've encountered a bug in libgit2 and we are going to have to
**force push** into [the Specs repository][master-repo]. (Also known as the
‘master’ spec repo.)

[master-repo]: https://github.com/CocoaPods/Specs

### What does this mean for you?

Well, basically your CocoaPods setup **is going to break**. You are going to
have to manually delete _any_ local copies of the Specs repository and re-clone
the new version of the Specs repository. You can do that with the following
commands:

    $ pod repo remove master
    $ pod setup

_**NOTE 1:** If you have any local commits or changes to the Specs repository
which are not merged, you should ensure you have a copy of them. I would
recommend that you manually copy these changes over and re-commit them. You can
fix your repository without deleting, however, this is not a simple process, so
we are instead recommending that you delete your copy of the Specs repository
and any forks of it._

_**NOTE 2:** In case you are storing private podspecs in your clone of the
Specs repository or you have a private spec repo that was forked from the
Specs repository, this is a great time to clean that up by using private spec
repositories [The Proper Way][private-repos]. This way your private spec
repository should never be affected by issues in other spec repositories._

[private-repos]: http://guides.cocoapods.org/making/private-cocoapods.html

<!-- more -->

### Why did this break?

The Specs repository has unfortunately broken due to a bug in libgit2 which
powers [GitHub's web editor][web-editor]. This has [caused our git repository
to become corrupt][spec-ticket] and the only solution is to rewrite the history
of the repository and force push the rewritten tree.

Rolling out this fix basically means that all copies of the repository have to
be reset. This can be a delicate process, so deleting and re-cloning is the
safest and simplest way to do so.

[web-editor]: https://help.github.com/articles/creating-and-editing-files-in-your-repository
[spec-ticket]: https://github.com/CocoaPods/Specs/issues/7029

### Will this happen again?

There is a [fix](https://github.com/libgit2/libgit2/pull/2085) in the works
to fix the bug in libgit2. This fixes a bug which would prevent libgit2 from
corrupting a repository in this particular case.

GitHub are also working on putting checking measures in-place on the
web-editor so that it wouldn't be possible to save a corrupt repository, and to
prevent any similar problems in the future. (As is already the case when using
[git-push][git-push], which runs [git-fsck][git-fsck] on GitHub’s end.)

[git-push]: https://www.kernel.org/pub/software/scm/git/docs/git-push.html
[git-fsck]: https://www.kernel.org/pub/software/scm/git/docs/git-fsck.html

### Acknowledgements

I would like to personally thank the following people for their help in both
investigating and resolving this matter.

- Jeff King ([@peff](https://github.com/peff))
- Roberto Tyley ([@rtyley](https://github.com/rtyley))
- Abizer Nasir ([@Abizern](https://github.com/Abizern))

We're sorry for the inconvenience this may cause.

