# Admin for testing searchable_select_options with filter option
ActiveAdmin.register Post, as: 'TestPostFilter' do
  menu false
  searchable_select_options(
    scope: Post,
    filter: ->(term, scope) { scope.where(title: term) },
    text_attribute: :title
  )
end
