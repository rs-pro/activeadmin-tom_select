# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Configure asset paths for Propshaft if available
if Rails.application.config.respond_to?(:assets)
  # Add the builds directory to asset paths for Propshaft
  Rails.application.config.assets.paths << Rails.root.join('app/assets/builds')
end
