source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

gem 'audited', '~> 4.9'
gem 'bcrypt', '3.1.12'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'bunny', '>= 2.14.1'
gem 'jwt'
gem 'kaminari'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'rails', '~> 6.0.0.rc2'
gem 'rswag'

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

group :development, :test do
  gem 'bunny-mock'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails', groups: %i[development test]
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-rails', '~> 3.6'
  gem 'rspec_junit_formatter'
  gem 'simplecov'
  gem 'timecop'
end

group :development do
  gem 'letter_opener'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rubocop-rails'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
