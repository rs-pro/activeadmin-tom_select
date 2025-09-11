require 'rails_helper'

require 'support/models'
require 'support/capybara'

RSpec.describe 'ajax params', type: :request do
  # Using static TestAjaxParamsPost and TestAjaxParamsCategory admins

  it 'passes parameters when rendering selected item' do
    user = User.create
    category = Category.create(name: 'Travel', created_by: user)
    post = Post.create(category: category)

    ApplicationController.current_user = user
    get "/admin/test_ajax_params_posts/#{post.id}/edit"

    expect(response.body).to have_selector('.searchable-select-input option[selected]',
                                           text: 'Travel')
  end

  it 'includes parameters in ajax url' do
    user = User.create

    ApplicationController.current_user = user
    get '/admin/test_ajax_params_posts/new'

    url_matcher = "?created_by=#{user.id}"
    expect(response.body).to have_selector('.searchable-select-input' \
                                           "[data-ajax-url*='#{url_matcher}']")
  end
end
