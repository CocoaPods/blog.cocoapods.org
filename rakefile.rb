#!/usr/bin/env rake

desc 'Build the site for deployment'
task :build do
  puts "Cloning submodules..."
  puts %x[git submodule update --init --recursive]

  puts "Compiling sass..."
  puts %x[sass _sass/main.scss css/main.css --style=compressed]

  puts "Building site..."
  puts %x[jekyll build]
end

