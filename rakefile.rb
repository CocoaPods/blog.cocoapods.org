#!/usr/bin/env rake

desc 'Initial setup'
task :init do
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

desc 'Runs the web server locally and watches for changes'
task :run do
  puts "Starting the sever locally on http://localhost:4000"
  sh "jekyll serve --watch --port 4000"
end


desc 'Deploy the site to the gh_pages branch and push'
task :deploy do

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

