ActiveAdmin.register Internal::TagName, as: 'Tag Name' do
  permit_params :name, :color_id

  index do
    selectable_column
    id_column
    column :name
    column :color
    actions
  end

  filter :color, as: :searchable_select, ajax: { resource: RgbColor }

  form do |f|
    f.inputs do
      f.input :name
      f.input :color, as: :searchable_select, ajax: { resource: RgbColor }
    end
    f.actions
  end
end
