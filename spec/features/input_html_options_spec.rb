require 'rails_helper'

require 'support/capybara'

RSpec.describe 'input_html options issue', type: :request do
  it 'should pass input_html class option to searchable select element' do
    # Using static TestInputHtmlPost and Category admins
    get '/admin/test_input_html_posts/new'

    # Parse the HTML response
    doc = Nokogiri::HTML(response.body)

    # Find the category select element by its ID
    category_select = doc.css('#post_category_id').first

    # Check if the element has the expected classes
    unless category_select
      raise "Category select element with ID 'post_category_id' not found in response"
    end

    classes = category_select['class'].to_s.split

    # The actual assertions
    expect(category_select).not_to be_nil, 'Category select element should exist'
    expect(classes).to include('searchable-select-input'),
                       "Select element should have 'searchable-select-input' class"
    expect(classes).to include('custom-class'),
                       "Select element should have 'custom-class' from input_html option"
  end
end
