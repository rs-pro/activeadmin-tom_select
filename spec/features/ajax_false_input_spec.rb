require 'rails_helper'

RSpec.describe 'ajax: false input behavior', type: :feature do
  before do
    # Create test data
    @users = 3.times.map { |i| User.create!(name: "User #{i + 1}") }
    @categories = 3.times.map { |i| Category.create!(name: "Category #{i + 1}") }

    @post = Post.create!(
      title: 'Test Post',
      body: 'Test content',
      category: @categories.first,
      user: @users.first
    )
  end

  describe 'filter inputs with ajax: false' do
    it 'renders all options inline without ajax URL' do
      visit '/admin/ajax_false_posts'

      # Should have tom-select-input class
      expect(page).to have_selector('.tom-select-input')

      # Should NOT have data-ajax-url attribute
      page_content = page.html
      expect(page_content).not_to match(/<select[^>]*name="q\[category_id_eq\]"[^>]*data-ajax-url/)
      expect(page_content).not_to match(/<select[^>]*name="q\[user_id_eq\]"[^>]*data-ajax-url/)

      # Should have options rendered inline
      within('select[name="q[category_id_eq]"]', visible: :all) do
        @categories.each do |category|
          expect(page).to have_selector("option[value='#{category.id}']", text: category.name,
                                                                          visible: :all)
        end
      end
    end
  end

  describe 'form inputs with ajax: false' do
    it 'renders all options inline in new form' do
      visit '/admin/ajax_false_posts/new'

      expect(page).to have_selector('.tom-select-input')

      # Check that options are rendered inline
      within('select#post_category_id', visible: :all) do
        @categories.each do |category|
          expect(page).to have_selector("option[value='#{category.id}']", text: category.name,
                                                                          visible: :all)
        end
      end
    end

    it 'preselects value in edit form' do
      visit "/admin/ajax_false_posts/#{@post.id}/edit"

      # Should have the selected option
      within('select#post_category_id', visible: :all) do
        selected_option = find("option[value='#{@categories.first.id}']", visible: :all)
        expect(selected_option).to be_selected
      end
    end
  end

  describe 'comparison with ajax: true (default)' do
    it 'default inputs use ajax' do
      visit '/admin/posts'

      # Default searchable_select should have data-ajax-url
      page_content = page.html
      expect(page_content).to match(/<select[^>]*name="q\[category_id_eq\]"[^>]*data-ajax-url/)
    end
  end
end
