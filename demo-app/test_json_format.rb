#!/usr/bin/env ruby
require_relative 'config/environment'

# Load ActiveAdmin
ActiveAdmin.load!

# Find the ActiveAdmin resource for User
namespace = ActiveAdmin.application.namespaces.first
resource = namespace.resources.find { |r| r.respond_to?(:resource_class) && r.resource_class == User }
option_collection = resource.searchable_select_option_collections[:all]

# Test the filtering
puts 'Testing search with term=test:'
params = { term: 'test', page: nil }
result = option_collection.as_json(nil, params)
puts JSON.pretty_generate(result)

puts "\nTesting without search term:"
params = { term: nil, page: nil }
result = option_collection.as_json(nil, params)
puts "Total results: #{result[:results].size}"
puts "First 3 results:"
result[:results].first(3).each do |r|
  puts "  - #{r[:text]} (ID: #{r[:id]})"
end

# Check ActiveAdmin's built-in JSON format
puts "\nActiveAdmin provides JSON format on index pages. You can use:"
puts "  GET /admin/users.json - for the index with filters"
puts "  GET /admin/users.json?q[name_cont]=test - for searching"