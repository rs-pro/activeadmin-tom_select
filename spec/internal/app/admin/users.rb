ActiveAdmin.register User do
  permit_params :name
  
  searchable_select_options(scope: User.all,
                           text_attribute: :name)
  
  index do
    selectable_column
    id_column
    column :name
    column :created_at
    actions
  end
  
  filter :name
  
  form do |f|
    f.inputs do
      f.input :name
    end
    f.actions
  end
end