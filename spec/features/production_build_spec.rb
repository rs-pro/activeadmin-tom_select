require 'rails_helper'
require 'support/models'
require 'support/capybara'
require 'support/active_admin_helpers'

RSpec.describe 'production build compatibility', type: :feature do
  # Using static admin files configured with searchable_select

  describe 'select2 initialization', js: true do
    it 'initializes select2 on searchable select inputs' do
      visit '/admin/posts'

      # Check that the searchable-select-input class is present
      expect(page).to have_css('.searchable-select-input')

      # Check that Select2 container is created
      expect(page).to have_css('.select2-container', wait: 5)
    end
  end

  describe 'basic functionality without JavaScript', js: false do
    it 'renders searchable select as a regular select' do
      Category.create(name: 'Books')
      Category.create(name: 'Movies')

      visit '/admin/posts/new'

      # Should have a select input with the searchable-select-input class
      expect(page).to have_css('select.searchable-select-input')
    end
  end

  describe 'ajax functionality', js: true do
    it 'loads options via ajax when clicked' do
      Category.create(name: 'Technology')
      Category.create(name: 'Science')

      visit '/admin/posts'

      # Open the filter select - click the first select2 container
      find('.select2-container', match: :first).click

      # Wait for ajax to load options
      expect(page).to have_css('.select2-results__option', text: 'Technology', wait: 5)
      expect(page).to have_css('.select2-results__option', text: 'Science')
    end

    it 'filters options based on search term' do
      Category.create(name: 'Ruby Programming')
      Category.create(name: 'Python Programming')
      Category.create(name: 'JavaScript')

      visit '/admin/posts'

      # Open the filter select - click the first select2 container
      find('.select2-container', match: :first).click

      # Type in search box
      find('.select2-search__field').set('Ruby')

      # Should only show matching option
      expect(page).to have_css('.select2-results__option', text: 'Ruby Programming', wait: 5)
      expect(page).not_to have_css('.select2-results__option', text: 'Python Programming')
      expect(page).not_to have_css('.select2-results__option', text: 'JavaScript')
    end
  end

  describe 'form submission', js: true do
    it 'submits selected value correctly' do
      category = Category.create(name: 'Test Category')

      visit '/admin/posts/new'

      fill_in 'Title', with: 'Test Post'

      # Wait for Select2 to initialize and select category using Select2
      sleep 0.5 # Allow time for Select2 to initialize
      within '#post_category_input' do
        find('.select2-container').click
      end
      find('.select2-results__option', text: 'Test Category').click

      click_button 'Create Post'

      # Verify the post was created with the correct category
      post = Post.last
      expect(post).to be_present
      expect(post.title).to eq('Test Post')
      expect(post.category).to eq(category)
    end
  end

  describe 'preselected values', js: true do
    it 'shows preselected value when editing' do
      category = Category.create(name: 'Selected Category')
      post = Post.create(title: 'Test', category: category)

      visit "/admin/posts/#{post.id}/edit"

      # Check that the selected value is displayed
      within '#post_category_input' do
        within '.select2-container' do
          expect(page).to have_content('Selected Category')
        end
      end
    end
  end
end
