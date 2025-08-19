ActiveAdmin.register Post do
  permit_params :title, :category_id, :user_id, :published
  
  searchable_select_options(scope: -> { Post.includes(:category, :user) },
                           text_attribute: :title)
  
  index do
    selectable_column
    id_column
    column :title
    column :category
    column :user
    column :published
    actions
  end
  
  filter :title
  filter :category, as: :searchable_select,
                   ajax: { resource: Category }
  filter :user, as: :searchable_select,
               ajax: { resource: User }
  filter :published
  
  form do |f|
    f.inputs do
      f.input :title
      f.input :category, as: :searchable_select,
                        ajax: { resource: Category }
      f.input :user, as: :searchable_select,
                    ajax: { resource: User }
      f.input :published
    end
    f.actions
  end
  
  show do
    attributes_table do
      row :title
      row :category
      row :user
      row :published
      row :created_at
      row :updated_at
    end
  end
end