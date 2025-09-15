# frozen_string_literal: true

# Ensure the Tom Select input is loaded for Formtastic
Rails.application.config.after_initialize do
  require 'activeadmin/tom_select'
end
