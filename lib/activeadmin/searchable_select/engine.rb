require 'active_admin'
require 'select2-rails'

module ActiveAdmin
  module SearchableSelect
    # @api private
    class Engine < ::Rails::Engine
      engine_name 'activeadmin_searchable_select'
      
      initializer 'activeadmin-searchable_select.assets' do
        if defined?(Importmap)
          # For Rails 7+ with importmap
          Rails.application.config.after_initialize do
            if Rails.application.config.respond_to?(:importmap)
              Rails.application.config.importmap.draw do
                pin "active_admin_searchable_select", to: "active_admin/searchable_select.js"
              end
            end
          end
        end
        
        # Add assets to precompile list
        config.assets.precompile += %w[
          active_admin/searchable_select.js
          active_admin/searchable_select.scss
          active_admin/searchable_select_tailwind.css
        ]
      end
    end
  end
end
