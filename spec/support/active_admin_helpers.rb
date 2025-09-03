module ActiveAdminHelpers
  module_function

  def reload_routes!
    if Rails.application && Rails.application.respond_to?(:reload_routes!)
      Rails.application.reload_routes!
    end
  end

  def setup
    ActiveAdmin.application = nil
    yield
    reload_routes!
  end
end
