# Admin for testing input_html options
ActiveAdmin.register Post, as: 'TestInputHtmlPost' do
  menu false
  permit_params :title, :category_id

  form do |f|
    f.input :title
    f.input :category, as: :searchable_select, input_html: { class: 'custom-class' },
                       ajax: { resource: Category }
  end
end
