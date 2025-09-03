ActiveAdmin.register RGB::Color, as: 'color' do
  permit_params :code, :description

  searchable_select_options(scope: RGB::Color,
                            text_attribute: :code)

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
