ActiveAdmin.register Post do
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

  filter :title
  filter :category, as: :searchable_select
  filter :user, as: :searchable_select

  form do |f|
    f.inputs do
      f.input :title
      f.input :body
      f.input :category, as: :searchable_select
      f.input :user, as: :searchable_select
    end
    f.actions
  end
end
