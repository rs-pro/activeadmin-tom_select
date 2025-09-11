# Admin for testing searchable_select_options with name prefix
ActiveAdmin.register Post, as: 'TestPostNamed' do
  menu false
  searchable_select_options(
    name: :some,
    scope: Post,
    text_attribute: :title
  )
end
