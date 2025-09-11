require 'rails_helper'

require 'support/models'
require 'support/capybara'
require 'support/active_admin_helpers'

RSpec.describe 'searchable select', type: :feature do
  it 'shows helpful error message if ajax resource cannot be auto detected' do
    ActiveAdminHelpers.setup do
      # Use a unique admin resource name to avoid conflicts
      ActiveAdmin.register(Post, as: 'TestErrorPost1') do
        menu false # Hide from menu to avoid conflicts

        # Try to use a filter with incorrect naming that can't be auto-detected
        filter(:custom_category_id_eq,
               as: :searchable_select,
               ajax: true)
      end
    end

    visit '/admin/test_error_post1s'
    expect(page).to have_content('Cannot auto detect resource')
  end

  it 'shows helpful error message if named option collection does not exist' do
    ActiveAdminHelpers.setup do
      # Register Post that tries to use non-existent 'nonexistent_collection' collection
      ActiveAdmin.register(Post, as: 'TestErrorPost2') do
        menu false # Hide from menu to avoid conflicts

        filter(:category,
               as: :searchable_select,
               ajax: {
                 resource: Category,
                 collection_name: 'nonexistent_collection' # This collection doesn't exist
               })
      end
    end

    visit '/admin/test_error_post2s'
    expect(page).to have_content(
      "No option collection named 'nonexistent_collection' defined in 'Category' admin."
    )
  end

  it 'shows helpful error message if ajax resource does not have an admin' do
    # Create a model that doesn't have an admin page
    unless defined?(NonAdminModel)
      Object.const_set('NonAdminModel', Class.new(ActiveRecord::Base))
      NonAdminModel.table_name = 'categories' # Use existing table
      NonAdminModel.class_eval do
        def self.ransackable_attributes(_auth_object = nil)
          ['name']
        end
      end
    end

    ActiveAdminHelpers.setup do
      # Register Post with a filter that references a model without an admin
      ActiveAdmin.register(Post, as: 'TestErrorPost3') do
        menu false # Hide from menu to avoid conflicts

        filter(:category,
               as: :searchable_select,
               ajax: {
                 resource: NonAdminModel
               })
      end
    end

    visit '/admin/test_error_post3s'
    expect(page).to have_content("No admin found for 'NonAdminModel'")
  ensure
    Object.send(:remove_const, 'NonAdminModel') if defined?(NonAdminModel)
  end
end
