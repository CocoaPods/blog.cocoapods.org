---
layout: post
title:  "Starting Open Source"
categories: open-source
author: hugo
date: 2014-10-25 
---

On July the 7th I attended the [CocoaHeads Stockholm](http://www.meetup.com/CocoaHeads-Stockholm/) meetup. For this particular meetup the brilliant, but unknown to me at the time, [Orta Therox](https://twitter.com/orta) held a talk about open source, [CocoaPods](http://cocoapods.org/) and how they work at [Artsy](https://artsy.net/).

For very long time beforehand I had felt that I was not contributing enough back to all the awesome projects that I used daily; CocoaPods being one of them. Orta really inspired me to take the first steps to contribute back. I promptly went home and started working on a issue I found among the [CocoaPods issues](https://github.com/CocoaPods/CocoaPods/issues) on GitHub. After finishing that I jumped straight on to another related issue. After a landing a few PRs I was invited to the CocoaPods slack team to discuss further. This post talks about my first steps into contributing back to a large project.

<!-- more -->

Why do Github issues often become filled people saying things like **+1**, **I need this** and **Would be awesome** instead of PRs solving the issue?

I can relate to this, I have made my fair share of **+1** and **I need this** comments. From my very personal, but probably non-unique experience, it's really a mentality issue more than anything. Ultimately it's related to my confidence as a programmer and a slight touch of [Impostor Syndrome](https://en.wikipedia.org/wiki/Impostor_syndrome).

### I can't provide value

A statement that I often used to justify my passivity was **I can't provide value here, the other contributors are just too skilled**. It's true that many open source projects are huge behemoths with a lot of code and things to understand, but every single contribution still matters and provides value to the project. A project without contributions, big or small, will stagnate.

I think there's also an important point to be made here about making the project accessible for new contributors. It should be as simple as possible to get started, that means setup of environment and finding issue which are suited for contributors who are not yet familiar with the code base. CocoaPods does both of these very well.

For setup there's a repository called [Rainforest](https://github.com/CocoaPods/Rainforest) which contains a rake task to setup everything needed to develop CocoaPods. Additionally almost all repositories contain a rake task called `bootstrap` which will setup the repository for development.

For finding issues CocoaPods uses a labelling systems to illustrate how difficult an issue is as seen [here](https://github.com/CocoaPods/CocoaPods/labels). The label `easy` is perfect for finding tasks for new contributors. In fact I have started working on quite a few of them, but many times I ran into problems which were too difficult or things I simply didn't understand well enough. I abandoned quite a few issues because of getting stuck, which is both good and bad. It's good because it's important that you are able to try your hand at solving issues and failing without being assigned the issue or feeling pressure to finish it. The bad part leads me to the next issue I had, asking questions.

### I shouldn't waste the core contributors time by asking trivial questions

Even after getting passed the initial feeling of not being able to provide any value, landing my first PR helped with this, I was still reluctant to ask the core contributors questions because I felt like I was wasting their time. To quote myself from a discussion we had.

> That's one of my concerns. I know that everyone else can implement trivial things much faster than me. I try to weigh asking question against that to not produce negative value

While it's true that having core contributors spending time on helping you might produce negative net value in the short term, in the long term you will end up with more developers who are productive and familiar with the code base.

This was best expressed by one of the core contributors.

> Let me just re-iterate @k0nserv: please ask us _any_ and _every_ question you have. That's why all of us work on CocoaPods


## Conclusion

After forcing myself to submit my first PR to CocoaPods things got a lot easier. I felt happy for contributing something and because it was received in a good way by the maintainers. Getting past my doubt to ask question was really only about getting told it wasn't the problem I was making it out to be.

So back to the original problem, since my first contributions to CocoaPods I have sent numerous PRs to other projects where I saw that something was lacking. This has been things like SSL improvements to the AWS cookbooks and a minor spelling error for a gem I was considering for work. I truly feel like I have stepped out of the **+1** mentality and into the **I'll submit a PR fixing the problem I found** mentality. Starting out with open source contributions is one of those things where you just need to take a plunge and soon you'll find yourself doing it naturally.

## Recommendations for contributors

Do you want to contribute to open source, but are having the same doubts as me or maybe completely different doubts? Here are my tips for getting started.

The initial hurdle is mainly about deciding to do it and picking a project. For the project it makes sense to pick something that you use yourself and even more so if you already have a task identified. If you don't have a specific task you want to work on checkout the issues on GitHub and if you can't find something that seems like a good fit for a new contributor in the issues ask the maintainers. Good candidates for projects are dependency managers, libraries, and other supporting tools.

So you picked your project and task and started working on it. If it's a fairly large project such as CocoaPods it's good to remember that it's perfectly fine that you don't grasp all the ins and outs of the code, in fact you don't have to. The important thing is understanding enough of the code which is related to the task you are working on. If you work with iOS or OSX CocoaPods is of course the perfect choice of project.

When you finished your task make sure that you have tests covering any new code or old tests which might have had to be adjusted also make sure that you're adhering to any style guides set by the project. Submit your PR and wait. Fix any issues raised by the maintainers and hopefully your PR will be merged. Good job!

The next time you find yourself frustrated with something missing or not working in an open source tool you use remember that you have the power to fix it!

## Recommendations for maintainers

If you want to have more contributors helping out with a project you are maintaining(why wouldn't you?) make sure that it's accessible and provide a good introduction for new contributors. This includes things like setup, running tests, code conventions, CI, labelling of issues.

Answer questions when asked and encourage a community where questions should be asked not silenced.

I feel like CocoaPods really is a good project to be inspired by in this regard. It's a truly an awesome project to get started with.


## And Remember

![You're awesome](http://media.giphy.com/media/q9fohf0Erd50A/giphy.gif)
