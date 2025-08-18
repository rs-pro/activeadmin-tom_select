require 'rails_helper'

require 'support/models'
require 'support/capybara'
require 'support/active_admin_helpers'

RSpec.describe 'searchable select', type: :feature do
  it 'shows helpful error message if ajax resource cannot be auto detected' do
    ActiveAdminHelpers.setup do
      ActiveAdmin.register(Post) do
        filter(:category_id_eq,
               as: :searchable_select,
               ajax: true)
      end
    end

    visit '/admin/posts'
    expect(page).to have_content('Cannot auto detect resource')
  end

  it 'shows helpful error message if named option collection does not exist' do
    ActiveAdminHelpers.setup do
      ActiveAdmin.register(Category) do
        searchable_select_options(scope: Category, text_attribute: :name)
      end

      ActiveAdmin.register(Post) do
        filter(:category,
               as: :searchable_select,
               ajax: {
                 collection_name: 'custom'
               })
      end
    end

    visit '/admin/posts'
    expect(page).to have_content("No option collection named 'custom' defined in 'Category' admin.")
  end

  it 'shows helpful error message if ajax resource does not have an admin' do
    ActiveAdminHelpers.setup do
      ActiveAdmin.register(Post) do
        filter(:category,
               as: :searchable_select,
               ajax: true)
      end
    end

    visit '/admin/posts'
    expect(page).to have_content("No admin found for 'Category'")
  end
end
