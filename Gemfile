source 'https://rubygems.org'

# ruby
ruby '2.1.5'

# rails
gem 'rails', '4.2.0'

# deploy
gem 'puma'
gem 'foreman'
gem 'newrelic_rpm'

# env
gem 'dotenv-rails'

# db
gem 'pg'
gem 'active_model_serializers', '~> 0.9.3'
gem 'friendly_id'
gem 'responders', '~> 2.0'

# users
gem 'devise'
gem 'omniauth'
gem 'omniauth-github'
gem 'omniauth-google-oauth2'
gem "octokit", "~> 3.0"

# front end
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'

# pipeline
gem 'slim-rails'

# markdown
gem 'github-markup'
gem 'redcarpet'

# Emails
gem 'premailer-rails'
gem 'nokogiri'

group :development do
  gem 'spring-commands-rspec'
end

group :development, :test do
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'pry-rails'
end

group :test do
  gem 'rspec-rails', '~> 3.1.0'
  gem 'capybara', '~> 2.4.3'
  gem 'vcr'
  gem 'webmock'
end

group :production do
  # Monitoring
  gem 'rollbar', '~> 1.3.1'
  gem 'rails_12factor'
end

gem "therubyracer"
