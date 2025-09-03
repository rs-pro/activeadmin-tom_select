# Admin for testing searchable_select_options with additional_payload as lambda
ActiveAdmin.register Post, as: 'TestPostPayloadLambda' do
  menu false
  searchable_select_options(
    scope: Post,
    text_attribute: :title,
    additional_payload: lambda do |record|
      { published: record.published }
    end
  )
end
