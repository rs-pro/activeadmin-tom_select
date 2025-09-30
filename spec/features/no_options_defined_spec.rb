require 'rails_helper'

require 'support/models'
require 'support/capybara'

RSpec.describe 'Admin without searchable_select_options defined', type: :feature, js: true do
  let(:category) { Category.create!(name: 'Test Category') }
  let(:user) { User.create!(name: 'Test User') }

  context 'when using searchable_select without defining options' do
    it 'should show proper error message on form page' do
      visit '/admin/post_without_options/new'

      # Check that error divs are present
      expect(page).to have_css('.searchable-select-error', minimum: 1)

      # Check for the improved error messages with code examples
      expect(page.html).to include('The required ajax endpoint is missing')
      expect(page.html).to include('ActiveAdmin.register Category do')
      expect(page.html).to include('searchable_select_options(text_attribute: :name)')
      expect(page.html).to include('Or disable ajax mode for this input')
    end

    it 'should show proper error message on filter page' do
      visit '/admin/post_without_options'

      # Check that error divs are present in filters
      expect(page).to have_css('.searchable-select-error', minimum: 1)

      # Check for improved error message
      expect(page.html).to include('The required ajax endpoint is missing')
      expect(page.html).to include('searchable_select_options')
    end
  end

  # The fix would be to test that ajax: false works without searchable_select_options
  # But since we need a dedicated admin resource for this, we'll test it separately
end
