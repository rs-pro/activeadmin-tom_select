#!/usr/bin/env ruby

ENV['RAILS_ENV'] = 'development'

require 'bundler/setup'
require 'combustion'

# Initialize Combustion with Rails components
Combustion.path = 'spec/internal'
Combustion.initialize!(:all) do
  config.load_defaults Rails::VERSION::STRING.to_f if Rails::VERSION::MAJOR >= 7

  # Development settings
  config.eager_load = false
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false
  config.action_dispatch.show_exceptions = :all

  # Assets
  config.assets.debug = true
  config.assets.compile = true
  config.assets.digest = false

  # Logging
  config.log_level = :debug

  # Mailer
  if config.respond_to?(:action_mailer)
    config.action_mailer.raise_delivery_errors = false
    config.action_mailer.perform_caching = false
  end
end

# Load models
Dir[File.expand_path('spec/internal/app/models/*.rb', __dir__)].each { |f| require f }

# Load ActiveAdmin configuration
require_relative 'spec/internal/config/initializers/active_admin'

# Load admin resources
Dir[File.expand_path('spec/internal/app/admin/*.rb', __dir__)].each { |f| require f }

# Ensure database exists and is seeded
begin
  ActiveRecord::Base.connection
rescue ActiveRecord::NoDatabaseError
  puts 'Creating database...'
  ActiveRecord::Tasks::DatabaseTasks.create_current
end

# Run migrations
ActiveRecord::Base.connection.migration_context.migrate

# Seed data if empty
if User.none?
  puts 'Seeding database...'
  load File.expand_path('spec/internal/db/seeds.rb', __dir__)
end

puts "\n#{'=' * 60}"
puts 'ActiveAdmin Searchable Select - Test App'
puts '=' * 60
puts "\nStarting server at: http://localhost:3000/admin"
puts "Use Ctrl+C to stop\n\n"

# Start Puma server
require 'rack'
require 'puma'

app = Rails.application
server = Puma::Server.new(app)
server.add_tcp_listener '127.0.0.1', 3000
server.run.join
