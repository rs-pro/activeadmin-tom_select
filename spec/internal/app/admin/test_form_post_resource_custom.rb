# Admin for testing form input with resource and custom collection name
ActiveAdmin.register Post, as: 'TestFormPostResourceCustom' do
  menu false
  form do |f|
    f.input(:category_id,
            as: :searchable_select,
            ajax: {
              resource: Category,
              collection_name: 'custom'
            })
  end
end
