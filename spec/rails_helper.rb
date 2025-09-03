require_relative 'spec_helper'

ENV['RAILS_ENV'] ||= 'test'

require 'combustion'

# Fix for FrozenError - initialize Combustion with proper configuration
Combustion.path = 'spec/internal'
Combustion.initialize!(:active_record, :action_controller, :action_view) do
  config.load_defaults Rails::VERSION::STRING.to_f if Rails::VERSION::MAJOR >= 7
end

require 'rspec/rails'
require 'capybara/rails'
require 'capybara-playwright-driver'
require 'database_cleaner/active_record'

# Load ActiveAdmin and models
require_relative 'internal/config/initializers/active_admin'

# Ensure ActiveAdmin loads properly with batch actions
ActiveAdmin.application.load!

require_relative 'internal/app/models/category'
require_relative 'internal/app/models/post'
require_relative 'internal/app/models/user'
require_relative 'internal/app/models/rgb_color'
require_relative 'internal/app/models/internal_tag_name'
require_relative 'internal/app/models/internal/tag_name'
require_relative 'internal/app/models/option_type'
require_relative 'internal/app/models/option_value'
require_relative 'internal/app/models/product'
require_relative 'internal/app/models/variant'

# Load admin files - this is crucial for static admin resources to be registered
Dir[File.expand_path('internal/app/admin/*.rb', __dir__)].each { |f| require f }

Dir[File.expand_path('support/**/*.rb', __dir__)].each { |f| require_relative f }

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
