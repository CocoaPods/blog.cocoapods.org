---
layout: post
title:  "Guides and Blog Deploys with Travis-CI"
author: michele
categories: blog guides website
---

TL;DR Both the Guides and Blog now auto-deploy when we push to master.

We are always looking for ways to make contributing to CocoaPods easier, and a quick win for us is auto-deploying the guides and blog. Now any member of the team can accept a PR, and Travis will deploy the changes within minutes.

<!-- more -->

##Scripts
Travis needs instructions on how to build this code. While you can add all of those commands to the Travis config directly, that is difficult to debug and removes the ability to manually setup and deploy.

Every CocoaPods repository has a `rake bootstrap` command to ensure the environment is setup, and every site has a `rake deploy` command. Taking the time to set these up in the past made it incredibly easy to integrate this process with Travis.

##Pushing to Github Pages with Travis
Setting up these two repositories to push to Github pages was pretty trivial, once I figured out the correct steps.

###1. Travis needs to be a user
Since Travis needs to push to Github, it needs a user. Pick or create a user, and get a Personal Access Token. This token is generated in Account Settings on Github. We chose to use the [CocoaPods Bot](https://github.com/CocoaPodsBot) account. 

###2. Authenticate with that user
In order to identify as this user, Travis needs credentials. I chose to encrypt the user information using the  `travis` gem. I ran the command below from within the project directory with the `add` flag so it automatically adds the encrypted output to the `.travis.yml`

```
travis encrypt 'GIT_NAME="Account Name" GIT_EMAIL=example@example.com GH_TOKEN=SOMEREALLYLONGSTRING' --add
```

###3. Setup and Deploy
Travis build on a completely fresh checkout, so setting up the environment is key. Thankfully both sites had the `rake bootstrap` command, so I was able to reuse that.

The deploy script turned out to be the tricky part. The important step here is to make sure the deploy script relies upon the `git remote` that's setup. All of our static sites have a `rake deploy` command, which I modified to remove the hardcoding of the remote.

###4. travis.yml
Configure git settings in `.travis.yml`. By default, Travis doesn't have a user, so you should set the `user.email` and `user.name` to push with. These should match the credentials you encrypted with the token.

```
install:
- git config --global user.email "bots@cocoapods.org"
- git config --global user.name "CocoaPods Bot"
```

###5. Updating the remote
In this setup, Travis doesn't have ssh access to the repository. Change the `git remote` to point to `https` with your token attached. The token is used to authenticate the push. Here's what the Blog setup looks like:

```
git remote set-url origin "https://${GH_TOKEN}@github.com/CocoaPods/blog.cocoapods.org.git"
```

###6. Turn on Travis builds
This is done from Settings. Also, since this is a deploying build, make sure that you *do not* build when pull requests are made.

###7. Commit and push your changes.
Hopefully everything will work. If not, you can make more changes, push, and wait for Travis to build.

#####The .travis.yml

```
language: ruby
branches:
  only:
  - master
rvm:
- 2.0.0
install:
- git config --global user.email "bots@cocoapods.org"
- git config --global user.name "CocoaPods Bot"
- rake bootstrap
script:
- git remote set-url origin "https://${GH_TOKEN}@github.com/CocoaPods/blog.cocoapods.org.git"
- rake deploy
env:
  global:
    secure: XXXX
```

##In Conclusion
So that's how we have our Travis deploys setup now. CocoaPods is a community effort, so lowering the barrier for contributions has been one of our goals. This new setup does just that. Edit away!