# Admin for testing searchable_select_options with lambda scope
ActiveAdmin.register Post, as: 'TestPostScopeLambda' do
  menu false
  searchable_select_options(
    scope: -> { Post.published },
    text_attribute: :title
  )
end
