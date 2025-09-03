require 'active_admin'

module ActiveAdmin
  module SearchableSelect
    # @api private
    class Engine < ::Rails::Engine
      engine_name 'activeadmin_searchable_select'

      initializer 'activeadmin_searchable_select.setup' do
        ActiveSupport.on_load(:active_admin) do
          require 'activeadmin/inputs/searchable_select_input'
          require 'activeadmin/inputs/filters/searchable_select_input'
        end
      end
    end
  end
end
