module ActiveAdminVersionHelpers
  def active_admin_version
    ActiveAdmin::VERSION
  end
  
  def active_admin_4?
    active_admin_version.to_i >= 4
  end
  
  def skip_for_active_admin_4
    skip "Not applicable for ActiveAdmin 4" if active_admin_4?
  end
  
  def skip_unless_active_admin_4
    skip "Only applicable for ActiveAdmin 4" unless active_admin_4?
  end
end

RSpec.configure do |config|
  config.include ActiveAdminVersionHelpers
end