module ActiveAdminHelpers
  module_function

  def reload_routes!
    # Try to reload routes if Rails application is available
    # This is needed after dynamically registering ActiveAdmin resources
    return unless defined?(Rails) && Rails.application

    begin
      Rails.application.reload_routes!
    rescue StandardError => e
      # In some test environments, reload_routes! might not work properly
      # but the routes are still loaded, so we can safely continue
      Rails.logger&.debug "Could not reload routes: #{e.message}"
    end
  end

  def setup
    ActiveAdmin.application = nil
    yield
    reload_routes!
  end
end
