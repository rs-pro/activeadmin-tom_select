require 'database_cleaner-active_record'

# Models are now defined in the Rails app under spec/internal/app/models/
# This file only keeps the database cleaner configuration

RSpec.configure do |config|
  config.after do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
  end
end
