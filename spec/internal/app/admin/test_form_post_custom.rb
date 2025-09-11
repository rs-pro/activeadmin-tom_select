# Admin for testing form input with custom collection name
ActiveAdmin.register Post, as: 'TestFormPostCustom' do
  menu false
  form do |f|
    f.input(:category,
            as: :searchable_select,
            ajax: {
              collection_name: 'custom'
            })
  end
end
