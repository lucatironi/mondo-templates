puts "==================================================="
puts "Mondo Template: Welcome!"
puts "Base template running"
puts "==================================================="
puts

puts "==================================================="
puts "Gems"
puts "==================================================="
puts

gem "authlogic"
gem "declarative_authorization", :source => "http://gemcutter.org"
gem "RedCloth", :lib => "redcloth"
gem "mislav-will_paginate", :lib => "will_paginate", :source => "http://gems.github.com"

rake "gems:install", :sudo => true

if yes?("Do you want to use a smtp?")
  initializer "mail.rb", <<-CODE
ActionMailer::Base.smtp_settings = {
  :address  => "smtp.sdabocconi.it",
  :port  => 25, 
  :domain  => "www.sdabocconi.it.com"
}
CODE
  puts "Smtp Configuration Done"
  puts
end

puts "==================================================="
puts "Compass"
puts "==================================================="
puts

# define dependencies
gem "haml", :lib => "haml", :version => ">=2.2.0"
gem "chriseppstein-compass", :source => "http://gems.github.com/", :lib => "compass"

# install and unpack
rake "gems:install GEM=haml", :sudo => true
rake "gems:install GEM=chriseppstein-compass", :sudo => true
rake "gems:unpack GEM=chriseppstein-compass"

# Require compass during plugin loading
file "vendor/plugins/compass/init.rb", <<-CODE
# This is here to make sure that the right version of sass gets loaded (haml 2.2) by the compass requires.
require "compass"
CODE

# integrate it!
run "haml --rails ."
run "compass --rails -f blueprint . --css-dir=public/stylesheets/compiled --sass-dir=app/stylesheets"

puts "Compass with blueprint is all setup, have fun!"

puts "========================================================"
puts "Adding some useful stuff"
puts "========================================================"
puts

initializer "form_errors.rb",
%q{ActionView::Base.field_error_proc = Proc.new do |html_tag, instance_tag|
  if html_tag =~ /<(input)[^>]+type=[""](radio|checkbox|hidden)/
    html_tag
  else
    "<span class='fieldWithErrors'>#{html_tag}</span>"
  end
end}

puts "==================================================="
puts "Removing unnecessary Rails files"
puts "==================================================="
puts

run "rm README"
run "rm public/index.html"
run "rm public/favicon.ico"
run "rm public/images/rails.png"

puts "==================================================="
puts "Git Initialization"
puts "==================================================="
puts

git :init

file ".gitignore", <<-END
.DS_Store
log/*.log
tmp/**/*
doc/api/*
doc/app/*
db/schema.rb
db/*.sqlite3
public/stylesheets/compiled/*
END

run "touch tmp/.gitignore log/.gitignore vendor/.gitignore public/stylesheets/compiled/.gitignore tmp/restart.txt"

git :add => ".", :commit => "-q -m 'initial commit'"

puts "==================================================="
puts "Done with Base template!"
puts "==================================================="
puts