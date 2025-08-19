require 'rails_helper'
require 'support/models'
require 'support/active_admin_helpers'

RSpec.describe 'Debug render filter', type: :request do
  it 'renders filters and prints HTML' do
    ActiveAdminHelpers.setup do
      ActiveAdmin.register(Post) do
        filter :category, as: :searchable_select
      end
    end
    get '/admin/posts'
    puts "Status: #{response.status}"
    body = response.body
    if response.status != 200
      msg = body.lines.grep(/exception-message|Exception|error/i).join
      puts msg.empty? ? body[0, 4000] : msg
    end
    expect(response.status).to eq(200)
  end
end
