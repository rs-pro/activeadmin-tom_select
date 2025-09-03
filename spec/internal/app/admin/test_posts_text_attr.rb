# Admin for testing searchable_select_options with text_attribute
ActiveAdmin.register Post, as: 'TestPostTextAttr' do
  menu false
  searchable_select_options(scope: Post, text_attribute: :title)
end
