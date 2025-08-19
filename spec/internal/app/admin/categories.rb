ActiveAdmin.register Category do
  permit_params :name, :created_by_id

  searchable_select_options(scope: Category.all,
                            text_attribute: :name)

  index do
    selectable_column
    id_column
    column :name
    column :created_by
    column :created_at
    actions
  end

  filter :name
  filter :created_by, as: :searchable_select,
                      ajax: { resource: User }

  form do |f|
    f.inputs do
      f.input :name
      f.input :created_by, as: :searchable_select,
                           ajax: { resource: User }
    end
    f.actions
  end
end
