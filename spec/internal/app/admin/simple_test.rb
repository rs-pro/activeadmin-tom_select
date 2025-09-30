# Test searchable_select_options with NO arguments
ActiveAdmin.register User, as: 'SimpleUser' do
  searchable_select_options # No arguments!

  permit_params :name

  index do
    id_column
    column :name
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
    end
    f.actions
  end
end
