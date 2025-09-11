# Admin for testing searchable_select_options with lambda scope that uses view helpers
ActiveAdmin.register Post, as: 'TestPostScopeUser' do
  menu false
  searchable_select_options(
    scope: -> { Post.where(user: current_user) },
    text_attribute: :title
  )
end
