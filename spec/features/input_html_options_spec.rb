require 'rails_helper'

require 'support/capybara'
require 'support/active_admin_helpers'

RSpec.describe 'input_html options issue', type: :request do
  it 'should pass input_html class option to searchable select element' do
    ActiveAdminHelpers.setup do
      ActiveAdmin.register(Category) do
        searchable_select_options(scope: Category, text_attribute: :name)
      end
      
      ActiveAdmin.register(Post) do
        permit_params :title, :category_id
        
        form do |f|
          f.input :title
          f.input :category, as: :searchable_select, input_html: { class: 'custom-class' }, ajax: { resource: Category }
        end
      end
    end

    get '/admin/posts/new'
    
    # Parse the HTML response
    doc = Nokogiri::HTML(response.body)
    
    # Find the category select element by its ID
    category_select = doc.css('#post_category_id').first
    
    # Check if the element has the expected classes
    if category_select
      classes = category_select['class'].to_s.split(' ')
      
      # The actual assertions
      expect(category_select).not_to be_nil, "Category select element should exist"
      expect(classes).to include('searchable-select-input'), 
        "Select element should have 'searchable-select-input' class"
      expect(classes).to include('custom-class'), 
        "Select element should have 'custom-class' from input_html option"
    else
      fail "Category select element with ID 'post_category_id' not found in response"
    end
  end
end