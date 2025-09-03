require 'rails_helper'
require 'support/models'
require 'support/active_admin_helpers'

# Minimal test to see what HTML is generated
ActiveAdminHelpers.setup do
  ActiveAdmin.register(Post) do
    form do |f|
      f.input :category, as: :searchable_select
    end
  end
end

Category.create!(name: 'Travel')
Category.create!(name: 'Music')

app = ActionDispatch::Integration::Session.new(Rails.application)
app.get '/admin/posts/new'

puts "Status: #{app.response.status}"
puts "\n=== FULL HTML RESPONSE ==="
puts app.response.body