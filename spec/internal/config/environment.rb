require 'combustion'

# Initialize the Combustion app in all environments (dev server and tests)
Combustion.path = 'spec/internal'
Combustion.initialize!(
  :active_record,
  :action_controller,
  :action_view,
  :propshaft,
  :action_mailer
) do
  config.load_defaults Rails::VERSION::STRING.to_f if Rails::VERSION::MAJOR >= 7

  # Friendly defaults for dev/test
  config.eager_load = false
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false
  config.action_dispatch.show_exceptions = :all

  # Propshaft assets (guarded in case of alternate stacks)
  if config.respond_to?(:assets)
    config.assets.debug = true
    config.assets.compile = true
  end

  # Logging
  config.log_level = :debug

  # Action Mailer
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.perform_caching = false
end

# Load ActiveAdmin configuration
require_relative 'initializers/active_admin'

# Load models
require_relative '../app/models/category'
require_relative '../app/models/post'
require_relative '../app/models/user'
require_relative '../app/models/rgb_color'
require_relative '../app/models/internal_tag_name'
require_relative '../app/models/option_type'
require_relative '../app/models/option_value'
require_relative '../app/models/product'
require_relative '../app/models/variant'

# The Rails application is initialized by Combustion
