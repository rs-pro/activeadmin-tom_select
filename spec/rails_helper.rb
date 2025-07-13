ENV['RAILS_ENV'] ||= 'test'

require 'combustion'
Combustion.initialize!(:active_record, :action_view, :sprockets)

require 'rspec/rails'
require 'support/reset_settings'
require 'support/active_admin_version'

# Fix for Rails 8 compatibility - fixture_path= method removal
if Rails.version.to_f >= 8.0 && !ActiveSupport::TestCase.respond_to?(:fixture_path=)
  class ActiveSupport::TestCase
    class << self
      attr_accessor :fixture_path
    end
  end
end

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!
end
