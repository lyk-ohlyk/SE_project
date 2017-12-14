source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# copied from https://stackoverflow.com/questions/28241981/rails-4-execjsprogramerror-in-pageswelcome
# this may fix the bug of "ActionView::Template::Error (TypeError: 对象不支持此属性或方法):"
gem 'coffee-script-source', '1.8.0'

gem 'bootstrap-sass', '~> 3.3.7'
#gem 'bcrypt-ruby', '~> 3.1.2'
#gem 'bcrypt-ruby', '3.0.1'
gem 'bcrypt', '3.1.11'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.4'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'

# add jquery-rails
gem 'jquery-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
  #rspec for learning how to test
  gem 'rspec-rails', '~> 3.6'
  gem 'guard-rspec', require: false

  gem 'factory_bot_rails'

  gem 'cucumber-rails', :require => false
  # database_cleaner is not required, but highly recommended


  #直接安装spork会出现下面的错误：
  #    spork-rails x86-mingw32 was resolved to 3.2.1, which depends on
  #    rails (< 3.3.0, >= 3.0.0) x86-mingw32
  #gem 'spork-rails'
  #spork 好像只支持rails 4，不再尝试这个了
  #gem 'spork-rails', github: 'railstutorial/spork-rails'
  #gem 'guard-spork', '1.5.0'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'database_cleaner', github: 'bmabey/database_cleaner'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
