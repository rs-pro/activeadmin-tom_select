# frozen_string_literal: true

require 'rubygems'
require 'bundler'

# Don't auto-require gems - we need to control loading order
Bundler.setup(:default, :development)

# Load Rails and combustion first
require 'combustion'

# Require propshaft explicitly before initializing
require 'propshaft' if defined?(Propshaft) || Bundler.load.specs.find { |s| s.name == 'propshaft' }

# Initialize Combustion with the Rails components we need
Combustion.initialize! :active_record, :action_controller, :action_view, :propshaft do
  config.load_defaults Rails::VERSION::STRING.to_f if Rails::VERSION::MAJOR >= 7
end

# Now that Rails is initialized, we can load ActiveAdmin and its dependencies
require 'active_admin'
require 'activeadmin/searchable_select'

# Ensure Formtastic input is loaded
require 'activeadmin/inputs/searchable_select_input'
require 'activeadmin/inputs/filters/searchable_select_input'

run Combustion::Application
