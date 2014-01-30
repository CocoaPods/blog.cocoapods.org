#!/usr/bin/env rake

desc 'Initial setup'
task :bootstrap do
  FileUtils.rm_rf '_gh-pages'
  puts "Cloning gh-pages branch..."
  puts %x[git clone git@github.com:CocoaPods/blog.cocoapods.org.git _gh-pages]
  Dir.chdir('_gh-pages') do
    puts %x[git checkout gh-pages]
  end

  puts "Cloning submodules..."
  puts %x[git submodule update --init --recursive]

  puts "Installing Bundle..."
  puts %x[bundle install]
end

# Deprecated, but leaving shortcut in because I'm sure Orta, at least, has this
# in his muscle-memory.
task :init => :bootstrap

namespace :run do
  desc 'Runs a local server *with* draft posts and watches for changes'
  task :drafts do
    puts "Starting the server locally on http://localhost:4000"
    sh "jekyll serve --watch --drafts --port 4000"
  end

  desc 'Runs a local server *without* draft posts and watches for changes'
  task :published do
    puts "Starting the server locally on http://localhost:4000"
    sh "jekyll serve --watch --port 4000"
  end
end

desc 'Deploy the site to the gh_pages branch and push'
task :deploy do
  FileUtils.rm_rf '_gh-pages'
  puts "Cloning gh-pages branch..."
  puts %x[git clone git@github.com:CocoaPods/blog.cocoapods.org.git _gh-pages]
  Dir.chdir('_gh-pages') do
    puts %x[git checkout gh-pages]
  end

  Dir.chdir("_gh-pages") do
    puts "Pulling changes from server."
    puts %x[git reset --hard]
    puts %x[git clean -xdf]
    puts %x[git checkout gh-pages]
    puts %x[git pull origin gh-pages]
  end

  puts "Building site."
  puts %x[jekyll build -d _gh-pages]

  Dir.chdir("_gh-pages") do
    puts "Pulling changes from server."
    puts %x[git checkout gh-pages]
    puts %x[git pull origin gh-pages]

    puts "Creating a commit for the deploy."

    puts %x[git ls-files --deleted -z | xargs -0 git rm;]
    puts %x[git add .]
    puts %x[git commit -m "Deploy"]

    puts "Pushing to github."
    puts %x[git push ]
  end
end

desc 'Defaults to run:drafts'
task :default => 'run:drafts'
