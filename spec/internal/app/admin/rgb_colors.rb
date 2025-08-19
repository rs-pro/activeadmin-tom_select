ActiveAdmin.register RgbColor do
  permit_params :code, :description
  
  searchable_select_options(scope: RgbColor.all,
                           text_attribute: :display_name)
  
  index do
    selectable_column
    id_column
    column :code
    column :description
    actions
  end
  
  filter :code
  filter :description
  
  form do |f|
    f.inputs do
      f.input :code
      f.input :description
    end
    f.actions
  end
end