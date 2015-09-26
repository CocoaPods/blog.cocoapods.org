---
layout: post
title:  "Running SSH Commands via Rakefiles"
author: orta
categories: cocoapods website
---

TL;DR: _CocoaDocs' commands which used to be executed via logging in are now done via rake commands._

[CocoaDocs](https://github.com/CocoaPods/cocoadocs.org/) runs a lot of CocoaPods' infrastructure. It is the workhorse that allows us to provide rendered [READMEs/CHANGELOGs](https://cocoapods.org/pods/ARAnalytics), [QIs](http://blog.cocoapods.org/CocoaPods.org-Two-point-Five/) and [status updates](https://status.cocoapods.org).

I have been manually `ssh`ing in to the server to execute commands for a [few years](https://github.com/CocoaPods/cocoadocs.org/commit/93e9896b04f79eb09be28a9056671b1d23f3143d), and it's a bit of a chore. Over time though, I became used to this. As more people were starting to help out in maintaining CocoaDocs, it became obvious that it needed to change from being dark arcane knowledge to easy -discoverable- commands.

<!-- more -->

Show me the code: [c7be695...a00338d](https://github.com/CocoaPods/cocoadocs.org/compare/c7be695...a00338d).

I initially explored the idea of using [Mina](http://nadarei.co/mina/) to let us treat CocoaDocs like we do with heroku. I spent a few hours setting it up, but never managed to get a single [working prototype](http://rampantgames.com/blog/?p=7745). Eventually I started looking for alternatives.

I found [net-ssh](https://github.com/net-ssh/net-ssh), which is a pleasant reminder of how old the ruby community is, given that docs are from [2004](http://net-ssh.github.io/ssh/v1/).  I used it to connect to the server in a tiny amount of code:

```ruby
require 'net/ssh'

Net::SSH.start('api.cocoadocs.org', 'cocoadocs', :password => "hahayeahright") do |ssh|
  output = ssh.exec!("hostname")
  puts output
end
```

Which was enough to start. Once I started though, I hit a problem. Each command is executed stateless-ly. What this means, in principal, is that your session won't stay in the same folder, and you won't have your normal shell setup. I started out trying to do all the things a shell would do `source ~/.zshrc` etc. etc. Not practical.

After giving up on the `exec`  function, I did some duckduckgo-ing for alternatives and found [a chapter on shell](http://net-ssh.github.io/ssh/v1/chapter-5.html#s3)  in the docs. However, the docs were out of date, and the code didn't exist. Luckily it had just been separated out into a  new gem: [net-ssh-shell](https://github.com/net-ssh/net-ssh-shell). This meant we could do:

``` ruby
require 'net/ssh'
require 'net/ssh/shell'

Net::SSH.start('api.cocoadocs.org', 'cocoadocs', :password => "hahayeahright") do |ssh|
  ssh.shell do |sh|
    sh.execute 'hostname'
  end
end
```

Which executes the command, as expected, as though you had logged in. Perfect. With that, I did some minor refactoring to turn it all into a function that takes some commands as an array.

``` ruby
 def run_ssh_commands commands
   puts "Connecting to api.cocoadocs.org:"
   Net::SSH.start('api.cocoadocs.org', 'cocoadocs') do |ssh|
     ssh.shell do |sh|
       sh.execute 'cd cocoadocs.org'
       commands.each do |command|
         puts command.yellow
         sh.execute command
       end
       sh.execute 'exit'
     end
   end
  end
```

I included an `exit` command to close the session at the end of the submitted commands, and that's it. Commands are now easily run from a maintainer's computer without the need for domain knowledge. They just need to know that `bundle exec rake -T` will give useful tasks. Given that we use Rakefile in all projects, this knowledge is implicit. Woo!

So, next time you hear people complaining about a chore you've become used to, take heed and try to automate the problem away.
