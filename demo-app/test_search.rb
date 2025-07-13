#!/usr/bin/env ruby
require_relative 'config/environment'

# Create test users
User.create(name: "Test User", email: "test@example.com", department: "Engineering") unless User.exists?(name: "Test User")
User.create(name: "Another User", email: "another@example.com", department: "Sales") unless User.exists?(name: "Another User")
User.create(name: "John Doe", email: "john@example.com", department: "Marketing") unless User.exists?(name: "John Doe")

# Test the filtering
puts "All users:"
User.all.each { |u| puts "  - #{u.name} (#{u.email})" }

puts "\nFiltering by 'test' using Ransack:"
filtered = User.ransack(name_cont: "test").result
filtered.each { |u| puts "  - #{u.name} (#{u.email})" }

puts "\nTesting the option collection filter:"
option_collection = ActiveAdmin::SearchableSelect::OptionCollection.new(:all, {
  scope: User.all,
  text_attribute: :name,
  display_text: ->(record) { record.display_name }
})

# Simulate the filter method
scope = User.all
term = "test"
filtered_scope = scope.ransack("name_cont" => term).result

puts "\nFiltered users with 'test':"
filtered_scope.each { |u| puts "  - #{u.name} (#{u.email})" }