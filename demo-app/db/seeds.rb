# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

# Create some users
10.times do |i|
  User.create!(
    name: "User #{i + 1}",
    email: "user#{i + 1}@example.com",
    department: ["Sales", "Marketing", "Engineering", "HR"].sample
  )
end

# Create some posts
User.all.each do |user|
  rand(1..3).times do |i|
    user.posts.create!(
      title: "Post #{i + 1} by #{user.name}",
      content: "This is the content of post #{i + 1} by #{user.name}. Lorem ipsum dolor sit amet."
    )
  end
end