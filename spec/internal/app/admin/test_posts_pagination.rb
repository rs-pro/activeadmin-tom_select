# Admin for testing searchable_select_options with pagination
ActiveAdmin.register Post, as: 'TestPostPagination' do
  menu false
  searchable_select_options(
    scope: Post,
    text_attribute: :title,
    per_page: 2
  )
end
