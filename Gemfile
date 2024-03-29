source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.1'
# Use sqlite3 as the database for Active Record
group :development, :test do
  gem 'sqlite3'
end
group :production do
  gem 'pg'
end
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
gem 'letter_opener', group: :development
gem 'nokogiri'
gem 'kaminari'
gem 'gon'
gem 'resque-retry'
gem 'resque-scheduler'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'shopify_app'
gem 'shopify_cli'
gem 'therubyracer'
gem 'fullcontact'
gem 'pry-rails'
gem 'figaro'
gem 'twitter-bootstrap-rails'
gem 'pry-nav'
gem 'responders', '~> 2.0'
gem 'rails_12factor'
gem 'rack-ssl-enforcer'
gem 'httparty'
gem 'redis'
gem 'redis-rails'
gem 'resque', require: 'resque/server'
gem 'whenever', require: false

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'web-console', '~> 2.0'
gem 'rollbar', '~> 2.3.0'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring

  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'better_errors'
end

group :test do
  gem 'webmock'
  gem 'shoulda-matchers'
  gem 'vcr'
  # gem 'webmock'
  gem 'rest-client'
  gem 'faker'
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'guard-rspec'
  gem 'launchy'
  gem 'cucumber-rails', require: false
  # database_cleaner is not required, but highly recommended
  gem 'database_cleaner'
end
