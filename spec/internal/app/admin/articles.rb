ActiveAdmin.register Post, as: 'Article' do
  permit_params :title, :body, :category_id, :user_id, :created_at, :updated_at

  index do
    selectable_column
    id_column
    column :title
    column :category
    column :user
    column :created_at
    actions
  end

  # Use the new tom_select input type
  filter :title
  filter :category, as: :tom_select, ajax: true
  filter :user, as: :tom_select, ajax: true

  form do |f|
    f.inputs do
      f.input :title
      f.input :body
      f.input :category, as: :tom_select, ajax: true
      f.input :user, as: :tom_select, ajax: true
    end
    f.actions
  end
end
