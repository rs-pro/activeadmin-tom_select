require 'rails_helper'

require 'support/models'
require 'support/capybara'
require 'support/active_admin_helpers'

RSpec.describe 'searchable select', type: :request do
  around do |example|
    if Rails.version >= "8.0"
      Rails.application.config.action_dispatch.show_exceptions = :none
    else
      Rails.application.config.action_dispatch.show_exceptions = false
    end
    example.run
    if Rails.version >= "8.0"
      Rails.application.config.action_dispatch.show_exceptions = :all
    else
      Rails.application.config.action_dispatch.show_exceptions = true
    end
  end
  it 'fails with helpful error message if ajax resource cannot be auto detected' do
    expect do
      ActiveAdminHelpers.setup do
        ActiveAdmin.register(Post) do
          filter(:category_id_eq,
                 as: :searchable_select,
                 ajax: true)
        end
      end

      get '/admin/posts'
    end.to raise_error(/Cannot auto detect resource/)
  end

  it 'fails with helpful error message if named option collection does not exist' do
    expect do
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

      get '/admin/posts'
    end.to raise_error(/No option collection named 'custom' defined in 'Category' admin./)
  end

  it 'fails with helpful error message if ajax resource does not have an admin' do
    expect do
      ActiveAdminHelpers.setup do
        ActiveAdmin.register(Post) do
          filter(:category,
                 as: :searchable_select,
                 ajax: true)
        end
      end

      get '/admin/posts'
    end.to raise_error(/No admin found for 'Category'/)
  end
end
