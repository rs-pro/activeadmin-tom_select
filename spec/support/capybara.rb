require 'capybara/rspec'

# Capybara configuration is now in rails_helper.rb
# Using Playwright driver for modern browser testing

RSpec.configure do |config|
  config.include Capybara::RSpecMatchers, type: :request
end
