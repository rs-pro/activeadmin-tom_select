ActiveAdmin.register Category do
  permit_params :name, :description, :created_at, :updated_at

  searchable_select_options(scope: Category, text_attribute: :name)

  index do
    selectable_column
    id_column
    column :name
    column :description
    column :created_at
    actions
  end

  filter :name
  filter :description

  form do |f|
    f.inputs do
      f.input :name
      f.input :description
    end
    f.actions
  end
end
