#!/usr/bin/env rake

desc 'Initial setup'
task :bootstrap do
  FileUtils.rm_rf '_gh-pages'
  puts 'Cloning gh-pages branch...'
  url = `git ls-remote --get-url origin`
  puts `git clone #{url.strip} _gh-pages`
  Dir.chdir('_gh-pages') do
    puts `git checkout gh-pages`
  end

  puts 'Cloning submodules...'
  puts `git submodule update --init --recursive`

  puts 'Installing Bundle...'
  puts `bundle install`
end

# Deprecated, but leaving shortcut in because I'm sure Orta, at least, has this
# in his muscle-memory.
task :init => :bootstrap

namespace :serve do
  desc 'Runs a local server *with* draft posts and watches for changes'
  task :drafts do
    puts 'Starting the server locally on http://localhost:4000'
    sh 'bundle exec jekyll serve --watch --drafts --port 4000'
  end

  desc 'Runs a local server *without* draft posts and watches for changes'
  task :published do
    puts 'Starting the server locally on http://localhost:4000'
    sh 'bundle exec jekyll serve --watch --port 4000'
  end
end

desc 'Runs a local server with draft posts and watches for changes'
task :serve => 'serve:drafts'

desc 'Deploy the site to the gh_pages branch and push'
task :deploy do
  # FileUtils.rm_rf '_gh-pages'
  # puts 'Cloning gh-pages branch...'
  # url = `git ls-remote --get-url origin`
  # puts `git clone #{url.strip} _gh-pages`
  Dir.chdir('_gh-pages') do
    puts `git checkout gh-pages`
  end

  Dir.chdir('_gh-pages') do
    puts 'Pulling changes from server.'
    puts `git reset --hard`
    puts `git clean -xdf`
    puts `git checkout gh-pages`
    puts `git pull origin gh-pages`
  end

  puts 'Building site.'
  puts `bundle exec jekyll build -d _gh-pages`

  Dir.chdir('_gh-pages') do
    puts 'Pulling changes from server.'
    puts `git checkout gh-pages`
    puts `git pull origin gh-pages`

    puts 'Creating a commit for the deploy.'

    puts `git ls-files --deleted -z | xargs -0 git rm;`
    puts `git add .`
    # puts `git commit -m "Deploy"`

    # puts 'Pushing to github.'
    # puts `git push --quiet > /dev/null 2>&1`
  end
end

desc 'Defaults to serve:drafts'
task :default => 'serve:drafts'
