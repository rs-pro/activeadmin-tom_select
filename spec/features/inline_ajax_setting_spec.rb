require 'rails_helper'

require 'support/models'
require 'support/capybara'

RSpec.describe 'inline_ajax_options setting', type: :request do
  describe 'when ajax option set to true ' do
    # Using static TestInlineAjaxPost and Category admins

    it 'renders all options statically' do
      Category.create!(name: 'Travel')
      Category.create!(name: 'Music')
      Category.create!(name: 'Cooking')

      ActiveAdmin::TomSelect.inline_ajax_options = true
      get '/admin/test_inline_ajax_posts/new'

      expect(response.body).to have_selector('.searchable-select-input option',
                                             text: 'Travel')
      expect(response.body).to have_selector('.searchable-select-input option',
                                             text: 'Music')
      expect(response.body).to have_selector('.searchable-select-input option',
                                             text: 'Cooking')
    end
  end
end
