require 'rails_helper'

require 'support/models'
require 'support/capybara'

ADMIN_POSTS_PATH = '/admin/posts'.freeze

RSpec.describe 'form input', type: :request do
  # The static admin/posts.rb file already configures searchable_select with ajax: true
  # So we'll test with that configuration
  describe 'with ajax option (from static admin file)' do
    before(:each) do
      ActiveAdmin::TomSelect.inline_ajax_options = true
    end

    after(:each) do
      ActiveAdmin::TomSelect.inline_ajax_options = false
    end
    it 'renders select input with searchable-select-input css class' do
      get "#{ADMIN_POSTS_PATH}/new"
      expect(response.body).to have_selector('select.searchable-select-input')
    end

    it 'renders options statically' do
      Category.create!(name: 'Travel')
      Category.create!(name: 'Music')

      get "#{ADMIN_POSTS_PATH}/new"

      expect(response.body).to have_selector('.searchable-select-input option', text: 'Travel')
      expect(response.body).to have_selector('.searchable-select-input option', text: 'Music')
    end

    it 'does not set data-ajax-url attribute' do
      get "#{ADMIN_POSTS_PATH}/new"

      expect(response.body).not_to have_selector('.searchable-select-input[data-ajax-url]')
    end
  end

  shared_examples 'renders ajax based searchable select input' do
    it 'renders select input with searchable-select-input css class' do
      get "#{ADMIN_POSTS_PATH}/new"

      expect(response.body).to have_selector('select.searchable-select-input')
    end

    it 'does not render options statically' do
      Category.create!(name: 'Travel')

      get "#{ADMIN_POSTS_PATH}/new"

      expect(response.body).not_to have_selector('.searchable-select-input option', text: 'Travel')
    end

    it 'sets data-ajax-url attribute' do
      get "#{ADMIN_POSTS_PATH}/new"

      expect(response.body).to have_selector('.searchable-select-input[data-ajax-url]')
    end

    it 'renders selected option for current value' do
      category = Category.create!(name: 'Travel')
      post = Post.create!(title: 'A post', category: category)

      get "#{ADMIN_POSTS_PATH}/#{post.id}/edit"

      expect(response.body).to have_selector('.searchable-select-input option[selected]',
                                             text: 'Travel')
    end
  end

  describe 'with ajax option set to true' do
    # Using static admin/posts.rb which already has ajax: true configured
    include_examples 'renders ajax based searchable select input'
  end

  describe 'with options collection name passed in ajax option' do
    # Using static TestFormPostCustom admin and categories.rb which has 'custom' collection
    include_examples 'renders ajax based searchable select input' do
      let(:admin_path_prefix) { 'test_form_post_customs' }

      def get(path)
        path = path.sub(ADMIN_POSTS_PATH, '/admin/test_form_post_customs')
        super
      end
    end
  end

  describe 'with options resource passed in ajax option' do
    # Using static TestFormPostResource admin
    include_examples 'renders ajax based searchable select input' do
      let(:admin_path_prefix) { 'test_form_post_resources' }

      def get(path)
        path = path.sub(ADMIN_POSTS_PATH, '/admin/test_form_post_resources')
        super
      end
    end
  end

  describe 'with options resource and collection name passed in ajax option' do
    # Using static TestFormPostResourceCustom admin and categories.rb which has 'custom' collection
    include_examples 'renders ajax based searchable select input' do
      let(:admin_path_prefix) { 'test_form_post_resource_customs' }

      def get(path)
        path = path.sub(ADMIN_POSTS_PATH, '/admin/test_form_post_resource_customs')
        super
      end
    end
  end

  describe 'with custom class attribute' do
    # Using static TestFormPostClass admin
    it 'adds searchable-select-input css class' do
      get '/admin/test_form_post_classes/new'

      expect(response.body).to have_selector('select.custom.searchable-select-input')
    end
  end
end
