require 'rails_helper'

require 'support/models'
require 'support/pluck_polyfill'

RSpec.describe 'searchable_select_options dsl', type: :request do
  describe 'with text_attribute option' do
    # Using static TestPostTextAttr admin
    describe 'creates JSON endpoint that' do
      it 'returns options for searchable select' do
        Post.create!(title: 'A post')

        get '/admin/test_post_text_attrs/all_options'

        expect(json_response).to match(results: [a_hash_including(text: 'A post',
                                                                  id: kind_of(Numeric))],
                                       pagination: { more: false })
      end

      it 'supports filtering via term parameter' do
        Post.create!(title: 'A post')
        Post.create!(title: 'Other post')
        Post.create!(title: 'Not matched')

        get '/admin/test_post_text_attrs/all_options?term=post'
        titles = json_response[:results].pluck(:text)

        expect(titles).to eq(['A post', 'Other post'])
      end
    end
  end

  describe 'with separate filter option' do
    # Using static TestPostFilter admin
    describe 'creates JSON endpoint that' do
      it 'returns options for searchable select' do
        Post.create!(title: 'A post')

        get '/admin/test_post_filters/all_options'

        expect(json_response).to match(results: [a_hash_including(text: 'A post',
                                                                  id: kind_of(Numeric))],
                                       pagination: { more: false })
      end

      it 'supports filtering via term parameter' do
        Post.create!(title: 'Post')
        Post.create!(title: 'Not matched')

        get '/admin/test_post_filters/all_options?term=Post'
        titles = json_response[:results].pluck(:text)

        expect(titles).to eq(['Post'])
      end
    end
  end

  describe 'with separate display_text option' do
    # Using static TestPostDisplayText admin
    describe 'creates JSON endpoint that' do
      it 'returns options for searchable select' do
        Post.create!(title: 'A post')

        get '/admin/test_post_display_texts/all_options'

        expect(json_response).to match(results: [a_hash_including(text: 'A POST',
                                                                  id: kind_of(Numeric))],
                                       pagination: { more: false })
      end

      it 'supports filtering via term parameter' do
        Post.create!(title: 'A post')
        Post.create!(title: 'Not matched')

        get '/admin/test_post_display_texts/all_options?term=post'
        titles = json_response[:results].pluck(:text)

        expect(titles).to eq(['A POST'])
      end
    end
  end

  describe 'pagination' do
    # Using static TestPostPagination admin
    it 'limits results and indicates that more results are available' do
      Post.create!(title: 'A post')
      Post.create!(title: 'Other post')
      Post.create!(title: 'Yet another post')

      get '/admin/test_post_paginations/all_options'

      expect(json_response[:results].size).to eq(2)
      expect(json_response[:pagination][:more]).to eq(true)
    end

    it 'allows passing page param' do
      Post.create!(title: 'A post')
      Post.create!(title: 'Other post')
      Post.create!(title: 'Yet another post')

      get '/admin/test_post_paginations/all_options?page=1'

      expect(json_response[:results].size).to eq(1)
      expect(json_response[:pagination][:more]).to eq(false)
    end
  end

  describe 'with additional_payload' do
    context 'as lambda' do
      # Using static TestPostPayloadLambda admin
      let!(:post) { Post.create!(title: 'A post', published: false) }

      subject { get '/admin/test_post_payload_lambdas/all_options' }

      it 'returns options with our additional attribute' do
        subject
        expect(json_response).to match(
          results: [{ text: 'A post', id: post.id, published: false }],
          pagination: { more: false }
        )
      end
    end

    context 'as Proc' do
      # Using static TestPostPayloadProc admin
      let!(:post) { Post.create!(title: 'A post', published: false) }

      subject { get '/admin/test_post_payload_procs/all_options' }

      it 'returns options with our additional attribute' do
        subject
        expect(json_response).to match(
          results: [{ text: 'A post', id: post.id, published: false }],
          pagination: { more: false }
        )
      end
    end
  end

  it 'allows passing lambda as scope' do
    # Using static TestPostScopeLambda admin
    Post.create!(title: 'Draft')
    Post.create!(title: 'Published post', published: true)

    get '/admin/test_post_scope_lambdas/all_options'
    titles = json_response[:results].pluck(:text)

    expect(titles).to eq(['Published post'])
  end

  it 'allows passing lambda as scope that uses view helpers' do
    # Using static TestPostScopeUser admin
    user = User.create!
    Post.create!(title: 'By current user', user: user)
    Post.create!(title: 'By other user', user: User.create!)

    ApplicationController.current_user = user
    get '/admin/test_post_scope_users/all_options'
    titles = json_response[:results].pluck(:text)

    expect(titles).to eq(['By current user'])
  end

  it 'allows passing lambda that takes params argument' do
    # Using static TestPostScopeParams admin
    user = User.create!
    Post.create!(title: 'By given user', user: user)
    Post.create!(title: 'By other user', user: User.create!)

    get "/admin/test_post_scope_params/all_options?user=#{user.id}"
    titles = json_response[:results].pluck(:text)

    expect(titles).to eq(['By given user'])
  end

  it 'allows passing name prefix for collection action' do
    # Using static TestPostNamed admin
    Post.create!(title: 'A post')

    get '/admin/test_post_nameds/some_options'

    expect(json_response).to include(results: array_including(a_hash_including(text: 'A post')))
  end

  it 'fails with helpful message if scope option is missing' do
    expect do
      ActiveAdminHelpers.setup do
        ActiveAdmin.register(Post) do
          searchable_select_options(text_attribute: :title)
        end
      end
    end.to raise_error(/Missing option: scope/)
  end

  it 'fails with helpful message if display_text are missing' do
    expect do
      ActiveAdminHelpers.setup do
        ActiveAdmin.register(Post) do
          searchable_select_options(scope: Post,
                                    filter: ->(_term, scope) { scope })
        end
      end
    end.to raise_error(/Missing option: display_text/)
  end

  it 'fails with helpful message if filter option is missing' do
    expect do
      ActiveAdminHelpers.setup do
        ActiveAdmin.register(Post) do
          searchable_select_options(scope: Post,
                                    display_text: ->(_term, scope) { scope })
        end
      end
    end.to raise_error(/Missing option: filter/)
  end

  def json_response
    JSON.parse(response.body).with_indifferent_access
  end
end
