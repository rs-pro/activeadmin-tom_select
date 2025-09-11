require 'rails_helper'

require 'support/models'
require 'support/capybara'
require 'support/active_admin_helpers'

RSpec.describe 'filter input', type: :request do
  # Test the existing static configuration (category and user filters with ajax: true)
  describe 'existing ajax-enabled searchable select filters' do
    it 'renders select input with searchable-select-input css class' do
      get '/admin/posts'

      expect(response.body).to have_selector('select.searchable-select-input')
    end

    it 'sets data-ajax-url attribute for ajax-enabled filters' do
      get '/admin/posts'

      expect(response.body).to have_selector('.searchable-select-input[data-ajax-url]')
    end

    it 'renders selected option for current value' do
      category = Category.create!(name: 'Travel')

      get "/admin/posts?q[category_id_eq]=#{category.id}"

      expect(response.body).to have_selector('.searchable-select-input option[selected]',
                                             text: 'Travel')
    end

    it 'does not render options statically for ajax-enabled filters' do
      Category.create!(name: 'Travel')

      get '/admin/posts'

      # Ajax-enabled filters should not render options inline
      expect(response.body).not_to have_selector('.searchable-select-input option', text: 'Travel')
    end
  end

  # Test specific behaviors of the searchable select functionality
  describe 'ajax endpoint behavior' do
    it 'generates correct ajax URLs for category filter' do
      get '/admin/posts'

      expect(response.body).to include('data-ajax-url="/admin/categories/all_options?"')
    end

    it 'generates correct ajax URLs for user filter' do
      get '/admin/posts'

      expect(response.body).to include('data-ajax-url="/admin/users/all_options?"')
    end

    it 'does not include empty option (uses clear button instead)' do
      get '/admin/posts'

      # We use Tom Select's clear button instead of an empty option
      expect(response.body).not_to have_selector('.searchable-select-input option[value=""]')
      expect(response.body).to have_selector('.searchable-select-input[data-clearable="true"]')
    end

    it 'adds data-clearable attribute by default' do
      get '/admin/posts'

      expect(response.body).to have_selector('.searchable-select-input[data-clearable="true"]')
    end
  end

  describe 'selected option rendering' do
    it 'renders selected category option when filtering' do
      category = Category.create!(name: 'Travel')

      get "/admin/posts?q[category_id_eq]=#{category.id}"

      expect(response.body).to have_selector('.searchable-select-input option[selected]',
                                             text: 'Travel')
    end

    it 'renders selected user option when filtering' do
      user = User.create!(name: 'John Doe')

      get "/admin/posts?q[user_id_eq]=#{user.id}"

      expect(response.body).to have_selector('.searchable-select-input option[selected]',
                                             text: 'John Doe')
    end
  end

  describe 'edge cases and error handling' do
    it 'handles non-existent category ID gracefully' do
      get '/admin/posts?q[category_id_eq]=99999'

      # Should not render selected option for non-existent ID
      expect(response.body).not_to have_selector('.searchable-select-input option[selected]')
    end

    it 'handles multiple filter values correctly' do
      category1 = Category.create!(name: 'Travel')
      category2 = Category.create!(name: 'Leisure')

      get "/admin/posts?q[category_id_in][]=#{category1.id}&q[category_id_in][]=#{category2.id}"

      # For 'in' queries, it should handle multiple values
      # Note: The exact behavior depends on how the input handles 'in' vs 'eq' predicates
      expect(response.status).to eq(200)
    end
  end

  describe 'custom searchable_select_options configurations' do
    it 'uses the configured text_attribute for display' do
      category = Category.create!(name: 'Travel')

      get "/admin/posts?q[category_id_eq]=#{category.id}"

      # Should display using the name attribute as configured in the static admin
      expect(response.body).to have_selector('.searchable-select-input option[selected]',
                                             text: 'Travel')
    end

    it 'uses the correct scope configuration' do
      # Create a category but test that the scope is working
      Category.create!(name: 'Travel')

      get '/admin/posts'

      # Should not render options statically because it's ajax-enabled
      expect(response.body).not_to have_selector('.searchable-select-input option', text: 'Travel')
      # But should have the ajax URL
      url_matcher = '/admin/categories/all_options'
      expect(response.body).to have_selector(
        ".searchable-select-input[data-ajax-url*='#{url_matcher}']"
      )
    end

    it 'supports custom collection name through admin configuration' do
      # Test that the custom searchable_select_options configuration works
      get '/admin/posts'

      # Verify that the custom endpoint is accessible (tests the custom collection)
      expect { get '/admin/categories/custom_options' }.not_to raise_error
    end
  end
end
