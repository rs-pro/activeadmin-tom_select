# Admin for testing form input with resource passed in ajax option
ActiveAdmin.register Post, as: 'TestFormPostResource' do
  menu false
  form do |f|
    f.input(:category_id,
            as: :searchable_select,
            ajax: {
              resource: Category
            })
  end
end
