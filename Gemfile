source 'https://rubygems.org'

ruby '3.2.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 7'
# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
# gem 'uglifier'
gem 'terser'

gem 'bootsnap', require: false

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Puma as the app server
gem 'puma'

gem 'awesome_print'

group :development, :test do
  gem 'dotenv-rails', '~> 2.1', '>= 2.1.1'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'listen'

  gem 'rspec_junit_formatter'

  # monitoring
  gem 'bullet'
  gem 'rack-mini-profiler', require: false
  gem 'flamegraph'
  gem 'stackprof'
  gem 'memory_profiler'

  gem 'webmock'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 4.0'

  gem 'letter_opener'
  gem 'pry'
  gem 'annotate'
end

group :test do
  gem 'vcr'
end

# Heroku fix
group :production do
  gem 'rack-timeout'
  gem 'font_assets'
end

# file uploades & assets
gem 'aws-sdk-s3', require: false

# caching
gem 'dalli' # memcache
gem 'rack-cache' # http caching

# sidekiq
gem 'sidekiq'

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'sprockets-rails', '>= 3.4.1'
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails', '~> 1.4'
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails', '~> 1.0', '>= 1.0.2'

gem 'cssbundling-rails', '~> 1.1.0'
gem 'jsbundling-rails', '~> 1.1.0'
gem 'babel-transpiler', '~> 0.7'
gem 'bootstrap',       '~> 4.0'
gem 'glyphicons',      '~> 1.0'
gem 'canonical-rails', '~> 0.2', '>= 0.2.10'
gem 'inline_svg',      '~> 1.5'
gem 'jquery-rails',    '~> 4.3'
gem 'responders'
gem 'sprockets', '~> 4.0'

# Spree gems
gem 'spree', '~> 4.5'
gem 'spree_sample', '~> 4.5'
gem 'spree_emails', '~> 4.5'
gem 'spree_backend', '~> 4.5'
gem 'spree_gateway', '~> 3.10'
gem 'spree_auth_devise', '~> 4.5'
gem 'spree_i18n', '~> 5.1'
gem 'spree_multi_vendor', '~> 2.4.0'
gem 'spree_dev_tools', require: false, group: %w[test development]

gem 'simple_form'

# Sentry Client
gem 'sentry-raven'

# Scout Client
gem 'scout_apm'

# Rack CORS Middleware
gem 'rack-cors'

# SendGrid
gem 'sendgrid-actionmailer'

# logging
gem 'remote_syslog_logger'

gem 'activerecord-nulldb-adapter'

# improved JSON rendering performance
gem 'oj'

# Fix SCSS errors with Ruby 3 on MacOS
gem 'sassc', github: 'sass/sassc-ruby', group: :development
# Use Redis for Action Cable
gem 'redis', '~> 4.0'

gem 'rubocop', require: false
gem 'rubocop-performance'
gem 'rubocop-rails'
