ActiveAdmin.register Category, as: 'CategoryWithAutoDefaults' do
  permit_params :name, :description

  # Test: searchable_select_options with NO arguments - should auto-detect everything!
  searchable_select_options

  index do
    selectable_column
    id_column
    column :name
    column :description
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
