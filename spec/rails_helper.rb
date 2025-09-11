require_relative 'spec_helper'

ENV['RAILS_ENV'] ||= 'test'

# Load required gems before Rails initialization
require 'devise'

# Load the Rails test application
require_relative 'internal/config/environment'

require 'rspec/rails'
require 'capybara/rails'
require 'capybara-playwright-driver'
require 'database_cleaner/active_record'

# Load support files
Dir[File.expand_path('support/**/*.rb', __dir__)].each { |f| require_relative f }

# Ensure ActiveAdmin loads properly with batch actions
ActiveAdmin.application.load!

# Configure Capybara with Playwright for modern browser testing
Capybara.register_driver :playwright do |app|
  Capybara::Playwright::Driver.new(app,
                                   browser_type: :chromium,
                                   headless: ENV['HEADLESS'] != 'false')
end

Capybara.default_driver = :rack_test
Capybara.javascript_driver = :playwright
Capybara.default_max_wait_time = 5

RSpec.configure do |config|
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  # Database cleaner setup
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  # Include Capybara DSL in feature specs
  config.include Capybara::DSL, type: :feature
end
