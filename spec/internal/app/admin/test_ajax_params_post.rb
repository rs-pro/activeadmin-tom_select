# Admin for testing ajax params with form
ActiveAdmin.register Post, as: 'TestAjaxParamsPost' do
  menu false
  controller do
    def current_user
      ApplicationController.current_user
    end
  end

  form do |f|
    f.input(:category,
            as: :searchable_select,
            ajax: {
              resource: 'TestAjaxParamsCategory',
              params: {
                created_by: current_user.id
              }
            })
  end
end
