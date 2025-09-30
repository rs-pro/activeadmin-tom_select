require 'rails_helper'

require 'support/models'
require 'support/capybara'

RSpec.describe 'searchable_select_options with auto-defaults', type: :feature, js: true do
  context 'when searchable_select_options is called without arguments' do
    it 'should work with auto-detected settings' do
      Category.create!(name: 'Electronics')
      Category.create!(name: 'Books')
      Category.create!(name: 'Clothing')

      # Test that the endpoint is created and works
      page.driver.browser.get('/admin/category_with_auto_defaults/all_options?term=book')

      json_response = JSON.parse(page.driver.browser.last_response.body)
      expect(json_response['results']).to be_an(Array)
      expect(json_response['results'].length).to eq(1)
      expect(json_response['results'][0]['text']).to eq('Books')
    end

    it 'should auto-detect name attribute for display' do
      Category.create!(name: 'Test Category')

      page.driver.browser.get('/admin/category_with_auto_defaults/all_options')

      json_response = JSON.parse(page.driver.browser.last_response.body)
      expect(json_response['results']).to be_an(Array)
      expect(json_response['results'][0]['text']).to eq('Test Category')
    end
  end

  context 'when model has title instead of name' do
    it 'should auto-detect title attribute' do
      # Create a temporary model with title instead of name
      ActiveAdmin.register Post, as: 'PostWithAutoDefaults' do
        searchable_select_options # No arguments!
      end

      Post.create!(title: 'My Blog Post', body: 'Content')

      page.driver.browser.get('/admin/post_with_auto_defaults/all_options')

      json_response = JSON.parse(page.driver.browser.last_response.body)
      expect(json_response['results']).to be_an(Array)
      expect(json_response['results'][0]['text']).to eq('My Blog Post')
    end
  end

  context 'error message for missing searchable_select_options' do
    it 'should show helpful error with no-argument example' do
      visit '/admin/post_without_options/new'

      # Check that the error message includes the simplified syntax
      expect(page).to have_css('.searchable-select-error', minimum: 1)
      expect(page.html).to include('searchable_select_options  # No arguments needed')
    end
  end
end
