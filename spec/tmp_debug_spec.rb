require 'rails_helper'
require 'support/models'
require 'support/active_admin_helpers'

RSpec.describe 'debug searchable select rendering', type: :request do
  it 'renders form with custom input' do
    ActiveAdminHelpers.setup do
      ActiveAdmin.register(Category) do
        searchable_select_options(scope: Category, text_attribute: :name)
      end
      ActiveAdmin.register(Post) do
        form do |f|
          f.input :category, as: :searchable_select, ajax: true
        end
      end
    end

    Category.create!(name: 'DebugCat')
    get '/admin/posts/new'
    if response.status != 200
      body = response.body
      msg = body.match(/<div class=\"exception-message\">\s*<div class=\"message\">([^<]+)<\/div>/m)
      puts "\n===== EXCEPTION: #{msg && msg[1]} =====\n"
      # Print first lines of backtrace snippet if present
      snippet = body.match(/<code class=\"traces\">[\s\S]*?<pre class=\"\">([\s\S]*?)<\/pre>/m)
      puts(snippet && snippet[1])
    end
    expect(response.status).to eq(200)
  end
end
