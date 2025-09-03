require 'rails_helper'
require 'support/models'
require 'support/active_admin_helpers'

RSpec.describe 'debug simple test', type: :request do
  before do
    ActiveAdminHelpers.setup do
      ActiveAdmin.register(Post) do
        form do |f|
          f.input :category, as: :searchable_select
        end
      end
    end
  end

  it 'debugs HTML output' do
    Category.create!(name: 'Travel')
    
    get '/admin/posts/new'
    
    puts "\n=== RESPONSE STATUS: #{response.status} ==="
    puts "\n=== LOOKING FOR HTML ELEMENTS ==="
    
    doc = Nokogiri::HTML(response.body)
    select_elements = doc.css('select')
    puts "Found #{select_elements.count} select elements total"
    
    select_elements.each_with_index do |element, i|
      puts "\nSelect #{i + 1}:"
      puts "  Classes: #{element['class']}"
      puts "  Name: #{element['name']}"
      puts "  Options count: #{element.css('option').count}"
      element.css('option').each do |opt|
        puts "    Option: '#{opt.text.strip}' (value: '#{opt['value']}')"
      end
      puts "  HTML: #{element.to_html}"
    end
    
    # Now check what we're looking for specifically
    searchable_selects = doc.css('.searchable-select-input')
    puts "\nFound #{searchable_selects.count} elements with searchable-select-input class"
    
    searchable_select_options = doc.css('.searchable-select-input option')
    puts "Found #{searchable_select_options.count} options within searchable-select-input"
  end
end