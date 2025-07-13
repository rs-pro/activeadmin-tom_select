ActiveAdmin.register User do
  permit_params :name, :email, :department
  
  searchable_select_options(scope: User, text_attribute: :display_name)
  
  index do
    selectable_column
    id_column
    column :name
    column :email
    column :department
    column :created_at
    actions
  end
  
  filter :name
  filter :email
  filter :department
  
  form do |f|
    f.inputs do
      f.input :name
      f.input :email
      f.input :department
    end
    f.actions
  end
end