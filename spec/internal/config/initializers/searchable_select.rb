# frozen_string_literal: true

# Ensure the Searchable Select input is loaded for Formtastic
Rails.application.config.after_initialize do
  require 'activeadmin/searchable_select'
end
