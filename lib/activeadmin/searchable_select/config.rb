module ActiveAdmin
  module SearchableSelect
    class Config
      def self.active_admin_version
        @active_admin_version ||= Gem::Version.new(ActiveAdmin::VERSION)
      end
      
      def self.active_admin_4?
        active_admin_version >= Gem::Version.new('4.0.0')
      end
      
      def self.use_importmap?
        defined?(Importmap) && Rails.application.config.respond_to?(:importmap)
      end
      
      def self.use_tailwind?
        active_admin_4?
      end
      
      def self.stylesheets
        if use_tailwind?
          ['active_admin/searchable_select_tailwind.css']
        else
          ['active_admin/searchable_select.scss']
        end
      end
    end
  end
end