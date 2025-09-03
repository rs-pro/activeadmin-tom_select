ActiveAdmin.register Variant do
  belongs_to :product

  permit_params :price, :option_value_id, :product_id

  index do
    selectable_column
    id_column
    column :price
    column :option_value
    actions
  end

  filter :price
  filter :option_value

  form do |f|
    f.inputs do
      f.input :price
      f.input(:option_value,
              as: :searchable_select,
              ajax: {
                resource: OptionValue,
                path_params: {
                  option_type_id: f.object.product&.option_type_id
                }
              })
    end
    f.actions
  end
end
