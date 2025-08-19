#!/usr/bin/env ruby

require 'bundler/setup'
require 'combustion'
require 'active_admin'

# Load models
Dir[File.expand_path('spec/internal/app/models/*.rb', __dir__)].each { |f| require f }

# Initialize Combustion with the test Rails app
Combustion.path = 'spec/internal'
Combustion.initialize!(:active_record, :action_controller, :action_view, :sprockets, :action_mailer) do
  config.load_defaults Rails::VERSION::STRING.to_f if Rails::VERSION::MAJOR >= 7
  
  # Development environment settings
  config.eager_load = false
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false
  
  # Show full error reports
  config.action_dispatch.show_exceptions = :all
  
  # ActiveAdmin configuration
  config.assets.debug = true
  config.assets.compile = true
  
  # Logging
  config.log_level = :debug
  
  # Action Mailer settings
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.perform_caching = false
end

# Load ActiveAdmin configuration
require_relative 'spec/internal/config/initializers/active_admin'

# Load admin resources
Dir[File.expand_path('spec/internal/app/admin/*.rb', __dir__)].each { |f| require f }

# Seed the database with sample data
puts "Seeding database..."
load File.expand_path('spec/internal/db/seeds.rb', __dir__)

# Start the server
puts "\n" + "="*60
puts "ActiveAdmin Searchable Select Test App"
puts "="*60
puts "\nServer starting on http://localhost:3000/admin"
puts "Press Ctrl+C to stop the server\n\n"

require 'rack'
require 'puma'

app = Rails.application
Rack::Server.new(app: app, Port: 3000, Host: '127.0.0.1').start