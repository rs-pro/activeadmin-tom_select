# Test admin for ajax: false scenarios
ActiveAdmin.register Post, as: 'AjaxFalsePost' do
  permit_params :title, :body, :category_id, :user_id, :color_id

  filter :title
  filter :category, as: :tom_select, ajax: false
  filter :user, as: :searchable_select, ajax: false

  form do |f|
    f.inputs do
      f.input :title
      f.input :body
      f.input :category, as: :tom_select, ajax: false
      f.input :user, as: :searchable_select, ajax: false
    end
    f.actions
  end
end
