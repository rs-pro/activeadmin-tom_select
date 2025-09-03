#!/usr/bin/env ruby

require 'rails_helper'
require 'support/models'
require 'support/active_admin_helpers'

ActiveAdminHelpers.setup do
  ActiveAdmin.register(Category) do
    searchable_select_options(scope: Category, text_attribute: :name)
  end

  ActiveAdmin.register(Post) do
    form do |f|
      f.input(:category,
              as: :searchable_select,
              ajax: true)
    end
  end
end

Category.create!(name: 'Travel')
Category.create!(name: 'Music')
Category.create!(name: 'Cooking')

ActiveAdmin::SearchableSelect.inline_ajax_options = true

# Make the request
app = ActionDispatch::Integration::Session.new(Rails.application)
app.get '/admin/posts/new'

puts "Response status: #{app.response.status}"
puts "Response content-type: #{app.response.content_type}"
puts "\n=== FULL RESPONSE BODY ==="
puts app.response.body
puts "\n=== SEARCHABLE SELECT SECTIONS ==="

# Look for searchable-select-input class
if app.response.body.include?('searchable-select-input')
  puts "Found searchable-select-input class"
  # Extract the select element
  doc = Nokogiri::HTML(app.response.body)
  select_elements = doc.css('.searchable-select-input')
  select_elements.each_with_index do |element, index|
    puts "Select element #{index + 1}:"
    puts element.to_html
    puts "Options:"
    element.css('option').each do |option|
      puts "  - #{option.text.strip}: #{option['value']}"
    end
  end
else
  puts "No searchable-select-input class found"
  
  # Look for any select elements
  doc = Nokogiri::HTML(app.response.body)
  select_elements = doc.css('select')
  puts "Found #{select_elements.count} select elements:"
  select_elements.each_with_index do |element, index|
    puts "Select element #{index + 1}:"
    puts "  Class: #{element['class']}"
    puts "  Name: #{element['name']}"
    puts "  ID: #{element['id']}"
    puts "  Options count: #{element.css('option').count}"
    element.css('option').each do |option|
      puts "    - #{option.text.strip}: #{option['value']}"
    end
  end
end