ENV['RAILS_ENV'] ||= 'test'

require 'combustion'
Combustion.initialize!(:active_record, :action_view, :sprockets)

require 'rspec/rails'
require 'support/reset_settings'
require 'support/active_admin_version'

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!
end
