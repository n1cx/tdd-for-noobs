source 'https://rubygems.org'

gem 'rails', '3.2.13'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'mysql2'      # database adapter
gem 'dalli'       # memcached client
gem 'slim'        # templating engine

group :development do
  gem 'debugger'
  gem 'guard'     # runs tests automatically
  gem 'foreman'     # manage app dependencies (redis, memcached, etc.)
  gem 'thin'      # faster web server
  gem 'faker'     # random values
end

group :test do
  gem 'guard-rspec'
  gem 'test_after_commit' # to fire after_commit AR hooks on spec
end

group :development, :test do
  gem 'rspec-rails'
  gem 'rspec-mocks'
  gem 'factory_girl_rails'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
