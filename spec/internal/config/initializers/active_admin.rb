ActiveAdmin.setup do |config|
  config.site_title = 'Test Admin'
  config.authentication_method = false
  config.current_user_method = false
  config.batch_actions = true
  config.filter_attributes = %i[encrypted_password password password_confirmation]
  config.localize_format = :long
  # Avoid rendering ActiveAdmin comments (routes are not mounted in Rails 8 test app)
  config.comments = false
end

# Load the tom_select module first
require 'activeadmin/tom_select'

# Register custom inputs with Formtastic
require 'activeadmin/inputs/searchable_select_input'
require 'activeadmin/inputs/filters/searchable_select_input'

# ActiveAdmin 4 expects importmap-rails in host apps. The Rails 8 test app uses
# esbuild instead, so provide minimal no-op shims so rendering
# doesn't error when calling `javascript_importmap_tags` and `ActiveAdmin.importmap`.
module ActiveAdmin
  # Provide a stub importmap accessor to satisfy `ActiveAdmin.importmap` calls
  def self.importmap
    nil
  end

  module Importmap
    def self.draw(*)
      # no-op in tests
    end
  end
end

# Provide a working `javascript_importmap_tags` helper that includes required JS for tests
module ActionView
  module Helpers
    module ImportmapHelperShim
      def javascript_importmap_tags(*, **)
        # In tests/dev, include built assets via Rails helpers so Propshaft
        # can resolve digested paths. Use proper Rails asset helpers for Propshaft.
        safe_join([
                    stylesheet_link_tag('active_admin', 'data-turbo-track': 'reload'),
                    javascript_include_tag('active_admin', 'data-turbo-track': 'reload',
                                                           defer: true)
                  ], "\n")
      end
    end
  end
end

ActiveSupport.on_load(:action_view) do
  include ActionView::Helpers::ImportmapHelperShim
end
