# Admin for testing inline_ajax_options setting
ActiveAdmin.register Post, as: 'TestInlineAjaxPost' do
  menu false
  form do |f|
    f.input(:category,
            as: :searchable_select,
            ajax: true)
  end
end
