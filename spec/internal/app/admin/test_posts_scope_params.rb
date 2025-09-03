# Admin for testing searchable_select_options with lambda that takes params argument
ActiveAdmin.register Post, as: 'TestPostScopeParams' do
  menu false
  searchable_select_options(
    scope: ->(params) { Post.where(user_id: params[:user]) },
    text_attribute: :title
  )
end
