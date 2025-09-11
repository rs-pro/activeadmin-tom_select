# Admin for testing form input with custom class attribute
ActiveAdmin.register Post, as: 'TestFormPostClass' do
  menu false
  form do |f|
    f.input :category, as: :searchable_select, input_html: { class: 'custom' }
  end
end
