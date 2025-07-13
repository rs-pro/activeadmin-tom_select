ENV['RAILS_ENV'] ||= 'test'

require 'combustion'

# Fix for Rails 8 compatibility - fixture_path= method removal
# This must be done before requiring rspec/rails
if defined?(ActiveSupport::TestCase) && !ActiveSupport::TestCase.respond_to?(:fixture_path=)
  class ActiveSupport::TestCase
    class << self
      attr_accessor :fixture_path
    end
  end
end

Combustion.initialize!(:active_record, :action_view, :sprockets)

require 'rspec/rails'
require 'support/reset_settings'
require 'support/active_admin_version'

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
