ActiveAdmin.register Post, as: 'PostWithoutOptions' do
  permit_params :title, :body, :category_id, :user_id

  # NOTE: This admin resource does NOT define searchable_select_options
  # but still tries to use searchable_select inputs - this should work
  # with ajax: false or fallback gracefully

  form do |f|
    f.inputs do
      f.input :title
      f.input :body
      # These should fail with the current bug
      f.input :category, as: :searchable_select
      f.input :user, as: :searchable_select
    end
    f.actions
  end

  filter :title
  # These should also fail with the current bug
  filter :category, as: :searchable_select
  filter :user, as: :searchable_select
end
