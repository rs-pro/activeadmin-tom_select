require 'rails_helper'

require 'support/models'
require 'support/capybara'
require 'support/active_admin_helpers'

RSpec.describe 'inline_ajax_options setting', type: :request do
  describe 'when ajax option set to true ' do
    before(:each) do
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
    end

    it 'renders all options statically' do
      Category.create!(name: 'Travel')
      Category.create!(name: 'Music')
      Category.create!(name: 'Cooking')

      ActiveAdmin::SearchableSelect.inline_ajax_options = true
      get '/admin/posts/new'

      puts "\n=== DEBUGGING HTML OUTPUT ==="
      puts "Response status: #{response.status}"
      if response.status == 500
        puts "=== 500 ERROR RESPONSE BODY ==="
        puts response.body
        puts "=== END ERROR RESPONSE ==="
      end
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
      end
      
      searchable_selects = doc.css('.searchable-select-input')
      puts "\nFound #{searchable_selects.count} elements with searchable-select-input class"

      expect(response.body).to have_selector('.searchable-select-input option',
                                             text: 'Travel')
      expect(response.body).to have_selector('.searchable-select-input option',
                                             text: 'Music')
      expect(response.body).to have_selector('.searchable-select-input option',
                                             text: 'Cooking')
    end
  end
end
