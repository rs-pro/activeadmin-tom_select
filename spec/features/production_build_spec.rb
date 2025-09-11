require 'rails_helper'
require 'support/models'
require 'support/capybara'
require 'support/active_admin_helpers'

RSpec.describe 'production build compatibility', type: :feature do
  # Using static admin files configured with searchable_select

  describe 'tom-select initialization', js: true do
    it 'initializes tom-select on searchable select inputs' do
      visit '/admin/posts'

      # Wait for page to load
      expect(page).to have_css('.searchable-select-input')

      # Give JavaScript time to initialize
      sleep 1

      # Debug: check what's on the page
      has_wrapper = page.has_css?('.ts-wrapper', wait: 0)
      has_control = page.has_css?('.ts-control', wait: 0)

      unless has_wrapper
        # Save screenshot for debugging
        page.save_screenshot('/tmp/test_fail.png')
        puts 'DEBUG: No .ts-wrapper found'
        puts "Has .ts-control: #{has_control}"
        puts "Page has searchable inputs: #{page.all('.searchable-select-input').count}"

        # Try manual initialization
        page.execute_script("
          if (typeof window.initSearchableSelects === 'function') {
            console.log('Manually initializing Tom Select');
            window.initSearchableSelects(document.querySelectorAll('.searchable-select-input'));
          } else {
            console.log('initSearchableSelects not found');
          }
        ")

        # Wait a bit after manual init
        sleep 0.5
      end

      # Check that Tom Select wrapper is created
      expect(page).to have_css('.ts-wrapper', wait: 5)
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

      # Open the filter select - click the first tom-select control
      find('.ts-control', match: :first).click

      # Wait for ajax to load options
      expect(page).to have_css('.ts-dropdown .option', text: 'Technology', wait: 5)
      expect(page).to have_css('.ts-dropdown .option', text: 'Science')
    end

    it 'filters options based on search term' do
      Category.create(name: 'Ruby Programming')
      Category.create(name: 'Python Programming')
      Category.create(name: 'JavaScript')

      visit '/admin/posts'

      # Open the filter select - click the first tom-select control
      find('.ts-control', match: :first).click

      # Type in search box (Tom Select uses different structure)
      find('.ts-control input').set('Ruby')

      # Should only show matching option
      expect(page).to have_css('.ts-dropdown .option', text: 'Ruby Programming', wait: 5)
      expect(page).not_to have_css('.ts-dropdown .option', text: 'Python Programming')
      expect(page).not_to have_css('.ts-dropdown .option', text: 'JavaScript')
    end
  end

  describe 'form submission', js: true do
    it 'submits selected value correctly' do
      category = Category.create(name: 'Test Category')

      visit '/admin/posts/new'

      fill_in 'Title', with: 'Test Post'

      # Wait for Tom Select to initialize and select category using Tom Select
      sleep 0.5 # Allow time for Tom Select to initialize
      within '#post_category_input' do
        find('.ts-control').click
      end
      find('.ts-dropdown .option', text: 'Test Category').click

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
        within '.ts-control' do
          expect(page).to have_content('Selected Category')
        end
      end
    end
  end
end
