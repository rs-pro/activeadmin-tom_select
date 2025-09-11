ActiveAdmin.register Product do
  permit_params :name, :option_type_id

  index do
    selectable_column
    id_column
    column :name
    column :option_type
    actions
  end

  filter :name
  filter :option_type

  form do |f|
    f.inputs do
      f.input :name
      f.input :option_type
    end
    f.actions
  end
end
