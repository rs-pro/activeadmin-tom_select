RSpec.configure do |config|
  config.before(:each) do
    ActiveAdmin::TomSelect.inline_ajax_options = false
  end
end
