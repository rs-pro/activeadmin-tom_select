ActiveAdmin.setup do |config|
  config.site_title = 'Test Admin'
  config.authentication_method = false
  config.current_user_method = false
  config.batch_actions = true
  config.filter_attributes = [:encrypted_password, :password, :password_confirmation]
  config.localize_format = :long
  # Avoid rendering ActiveAdmin comments (routes are not mounted in Combustion app)
  config.comments = false
end

# Register custom inputs with Formtastic
require 'activeadmin/inputs/searchable_select_input'
require 'activeadmin/inputs/filters/searchable_select_input'

# ActiveAdmin 4 expects importmap-rails in host apps. The Combustion app used
# for tests doesn't include it, so provide minimal no-op shims so rendering
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
        # In the test environment, manually include jQuery, Select2, and our custom JS
        content = []
        
        # Add Select2 CSS from CDN
        content << '<link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />'
        
        # Add jQuery from CDN
        content << '<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>'
        
        # Add Select2 from CDN
        content << '<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>'
        
        # Add our searchable select initialization code
        content << '<script type="text/javascript">'
        # Use the correct path relative to the gem root
        js_file_path = File.expand_path('../../../../../app/assets/javascripts/active_admin/searchable_select/init.js', __FILE__)
        content << File.read(js_file_path)
        content << '</script>'
        
        content.join("\n").html_safe
      end
    end
  end
end

ActiveSupport.on_load(:action_view) do
  include ActionView::Helpers::ImportmapHelperShim
end
