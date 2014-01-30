---
layout: post
title:  "Repairing Our Broken Specs Repository"
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

<pre class='highlight'><code>
    $ pod repo remove master
    $ pod setup
    
</code></pre>

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

_If you really know what you’re doing and don’t want to re-download the
complete repo, follow [these][advanced-instructions] instructions._

[advanced-instructions]: https://github.com/CocoaPods/Specs/issues/7029#issuecomment-33708256

### Why did this break?

The Specs repository has unfortunately broken due to [a bug in
libgit2][libgit2-ticket] which powers [GitHub's web editor][web-editor]. This
has [caused our git repository to become corrupt][spec-ticket]:

> As fsck noted, it has duplicate entries, which is a violation of Git's object
> format. GitHub check objects as they are pushed into each fork; anyone who
> has built on top of the broken tree will have their push rejected, as they
> are trying to bring the broken object into their fork (as a result of it
> being reachable from their new commits).
>
> We are looking into how this broken object got into the repository in the
> first place. At this point it looks like a web-edit […], that was then merged
> on the site via a pull request ([…] it looks like a bug in GitHub rather than
> any kind of user error). We're looking both into fixing the bug, but also
> into giving better protection to broken objects entering the repository (i.e.
> this is the exact sort of problem that the fsck-on-push checks are there to
> prevent, but they do not currently extend to web edits).

The only solution is to rewrite the history of the repository and force push
the rewritten tree. Rolling out this fix basically means that all copies of the
repository have to be reset. This can be a delicate process, so deleting and
re-cloning is the safest and simplest way to do so.

[libgit2-ticket]: https://github.com/libgit2/libgit2/pull/2085
[web-editor]: https://help.github.com/articles/creating-and-editing-files-in-your-repository
[spec-ticket]: https://github.com/CocoaPods/Specs/issues/7029#issuecomment-33429321

### Will this happen again?

There is a [fix][libgit2-ticket] in the works to fix the bug in libgit2. This
fixes a bug which would prevent libgit2 from corrupting a repository in this
particular case.

GitHub are also working on putting checking measures in-place on the
web-editor so that it wouldn't be possible to save a corrupt repository, and to
prevent any similar problems in the future. (As is already the case when using
[git-push][git-push], which runs [git-fsck][git-fsck] on GitHub’s end.)

[git-push]: https://www.kernel.org/pub/software/scm/git/docs/git-push.html
[git-fsck]: https://www.kernel.org/pub/software/scm/git/docs/git-fsck.html

### Acknowledgements

We would like to thoroughly thank the following people for their help in both
investigating and resolving this matter. It is very much appreciated by all of
us at CocoaPods HQ and shows the power of a (larger) community of people coming
together.

- Jeff King ([@peff](https://github.com/peff))
- Roberto Tyley ([@rtyley](https://github.com/rtyley))
- Abizer Nasir ([@Abizern](https://github.com/Abizern))

We are very sorry for _all_ time this issue takes away from our great early
adopters and pod providers. We are very thankful for your patience and
understanding while we work towards a smoothly functioning version 1 of
CocoaPods and its architecture.

**<3**

– [@kylefuller](https://twitter.com/kylefuller),
[@SmileyKeith](https://twitter.com/SmileyKeith), and
[@alloy](https://twitter.com/alloy)
