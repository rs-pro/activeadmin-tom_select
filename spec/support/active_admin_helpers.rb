module ActiveAdminHelpers
  module_function

  def reload_routes!
    return unless Rails.application

    Rails.application.reload_routes!
  end

  def setup
    # Since we can't easily override static registrations,
    # just yield to let tests define additional config if needed
    # Most tests will need to be updated to work with existing static admin files
    yield if block_given?
    reload_routes!
  end
end
