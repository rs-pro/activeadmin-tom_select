# Admin for testing ajax params with custom scope
ActiveAdmin.register Category, as: 'TestAjaxParamsCategory' do
  menu false
  searchable_select_options(
    scope: lambda do |params|
      Category.where(created_by_id: params[:created_by])
    end,
    text_attribute: :name
  )
end
