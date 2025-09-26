ActiveAdmin.register OptionValue do
  belongs_to :option_type, optional: true

  permit_params :name, :option_type_id

  searchable_select_options(scope: lambda do |params|
    OptionValue.where(
      option_type_id: params[:option_type_id]
    )
  end,
                            text_attribute: :name)

  index do
    selectable_column
    id_column
    column :name
    column :option_type
    actions
  end

  filter :name

  form do |f|
    f.inputs do
      f.input :name
      f.input :option_type
    end
    f.actions
  end
end
