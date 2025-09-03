# Admin for testing searchable_select_options with display_text option
ActiveAdmin.register Post, as: 'TestPostDisplayText' do
  menu false
  searchable_select_options(
    scope: Post,
    display_text: ->(record) { record.title.upcase },
    text_attribute: :title
  )
end
