# Admin for testing searchable_select_options with additional_payload as proc
ActiveAdmin.register Post, as: 'TestPostPayloadProc' do
  menu false
  searchable_select_options(
    scope: Post,
    text_attribute: :title,
    additional_payload: proc { |record| { published: record.published } }
  )
end
