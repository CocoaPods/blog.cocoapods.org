#!/usr/bin/env rake

desc 'Start up the jekyll & sasss processed'
task :dev do
  puts "Starting Jekyll & Sass"
  puts %x[jekyll serve --detach]
  puts %w[sass --watch _sass/css &]
end

desc 'Close the dev environment'
task :end do
  puts "Closing jekyll & sass"
  puts %x[killall jekyll]
  puts %w[killall sass]
end

desc 'Build the site for deployment'
task :build do
  puts "Cloning submodules..."
  puts %x[git submodule update --init --recursive]
end

desc 'Deploy the site to the gh_pages branch and push'
task :deploy do

  puts "Compiling sass."
  puts %x[sass _sass/*.scss css/ --style=compressed]

  puts "Building site."
  puts %x[jekyll build -d _gh-pages]
  
  Dir.chdir("_gh-pages") do
    puts "Pulling changes from server."
    puts %x[git pull origin gh-pages]

    puts "Creating a commit for the deploy."
    
    puts %x[git ls-files --deleted -z | xargs -0 git rm;]
    puts %x[git add .]
    puts %x[git commit -m "Deploy"]
    
    puts "Pushing to github."
    puts %x[git push ]
  end
end

