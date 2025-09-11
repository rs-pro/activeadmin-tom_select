ActiveAdmin.register OptionValue do
  belongs_to :option_type

  permit_params :value, :option_type_id

  searchable_select_options(scope: lambda do |params|
    OptionValue.where(
      option_type_id: params[:option_type_id]
    )
  end,
                            text_attribute: :value)

  index do
    selectable_column
    id_column
    column :value
    column :option_type
    actions
  end

  filter :value

  form do |f|
    f.inputs do
      f.input :value
      f.input :option_type
    end
    f.actions
  end
end
