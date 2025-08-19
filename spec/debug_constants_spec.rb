require 'rails_helper'

RSpec.describe 'ActiveAdmin input namespaces', type: :request do
  it 'prints available input namespaces' do
    mod_inputs = defined?(ActiveAdmin::Inputs) ? ActiveAdmin::Inputs.constants : []
    mod_filters_inputs = if defined?(ActiveAdmin::Filters::Inputs)
                           ActiveAdmin::Filters::Inputs.constants
                         else
                           []
                         end
    mod_inputs_filters = if defined?(ActiveAdmin::Inputs::Filters)
                           ActiveAdmin::Inputs::Filters.constants
                         else
                           []
                         end
    puts "ActiveAdmin::Inputs constants: #{mod_inputs.sort.inspect}"
    puts "ActiveAdmin::Inputs::Filters constants: #{mod_inputs_filters.sort.inspect}"
    puts "ActiveAdmin::Filters::Inputs constants: #{mod_filters_inputs.sort.inspect}"
    expect(true).to be(true)
  end
end
