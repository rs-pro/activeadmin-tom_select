# This file should ensure the existence of records required to run the application in every
# environment (production, development, test). The code here should be idempotent so that it
# can be executed at any point in every environment. The data can then be loaded with the
# bin/rails db:seed command (or created alongside the database with db:setup).

# Create admin user for ActiveAdmin
AdminUser.find_or_create_by(email: 'admin@example.com') do |admin|
  admin.password = 'password'
  admin.password_confirmation = 'password'
end

# Create sample users
users = []
10.times do |i|
  users << User.find_or_create_by(name: "User #{i + 1}") do |user|
    user.email = "user#{i + 1}@example.com"
  end
end

# Create sample categories with created_by association
categories = []
5.times do |i|
  categories << Category.find_or_create_by(name: "Category #{i + 1}") do |category|
    category.description = "Description for category #{i + 1}"
    category.created_by = users.sample
  end
end

# Create sample posts with published status
20.times do |i|
  Post.find_or_create_by(title: "Post #{i + 1}") do |post|
    post.body = "Body content for post #{i + 1}"
    post.category = categories.sample
    post.user = users.sample
    post.published = [true, false].sample
    post.position = i
    # We'll set color_id after colors are created
  end
end

# Create RGB colors
rgb_colors_data = [
  { code: '#FF0000', description: 'Red' },
  { code: '#00FF00', description: 'Green' },
  { code: '#0000FF', description: 'Blue' },
  { code: '#FFFF00', description: 'Yellow' },
  { code: '#FF00FF', description: 'Magenta' },
  { code: '#00FFFF', description: 'Cyan' },
  { code: '#000000', description: 'Black' },
  { code: '#FFFFFF', description: 'White' }
]

rgb_colors = rgb_colors_data.map do |color|
  RgbColor.find_or_create_by(code: color[:code]) do |rgb|
    rgb.description = color[:description]
  end
end

# Create internal tag names
10.times do |i|
  InternalTagName.find_or_create_by(name: "Internal Tag #{i + 1}") do |tag|
    tag.description = "Description for internal tag #{i + 1}"
    tag.color_id = rgb_colors.sample.id
  end
end

# Create option types and values
option_types = []
3.times do |i|
  option_type = OptionType.find_or_create_by(name: "Option Type #{i + 1}")
  option_types << option_type

  5.times do |j|
    OptionValue.find_or_create_by(
      value: "Value #{j + 1} for #{option_type.name}",
      option_type_id: option_type.id
    )
  end
end

# Create products and variants
10.times do |i|
  product = Product.find_or_create_by(name: "Product #{i + 1}") do |p|
    p.option_type = option_types.sample
  end

  3.times do |j|
    option_value = product.option_type&.option_values&.sample
    option_value_id = option_value&.id || OptionValue.first&.id

    Variant.find_or_create_by(
      product_id: product.id,
      option_value_id: option_value_id
    ) do |variant|
      variant.price = (10 + j) * 100
    end
  end
end

# Create Colors (different from RGB colors)
colors_data = [
  { name: 'Red', hex: '#FF0000' },
  { name: 'Green', hex: '#00FF00' },
  { name: 'Blue', hex: '#0000FF' },
  { name: 'Orange', hex: '#FFA500' },
  { name: 'Purple', hex: '#800080' }
]

colors = colors_data.map do |color_attrs|
  Color.find_or_create_by(name: color_attrs[:name]) do |color|
    color.hex = color_attrs[:hex]
  end
end

# Update posts with colors
Post.all.each do |post|
  post.update(color: colors.sample) if post.color_id.nil?
end

# Create Tags
tags_data = [
  { name: 'Ruby' },
  { name: 'Rails' },
  { name: 'JavaScript' },
  { name: 'CSS' },
  { name: 'HTML' },
  { name: 'ActiveAdmin' },
  { name: 'Testing' }
]

tags = tags_data.map do |tag_attrs|
  Tag.find_or_create_by(name: tag_attrs[:name])
end

# Create some taggings (many-to-many between posts and tags)
Post.all.sample(10).each do |post|
  tags.sample(rand(1..3)).each do |tag|
    Tagging.find_or_create_by(post_id: post.id, tag_id: tag.id)
  end
end

# Create Articles
5.times do |i|
  Article.find_or_create_by(title: "Article #{i + 1}") do |article|
    article.body = "Body content for article #{i + 1}"
    article.category = categories.sample
  end
end

puts '=' * 50
puts 'Seed data created successfully!'
puts '=' * 50
puts "AdminUsers:        #{AdminUser.count}"
puts "Users:             #{User.count}"
puts "Categories:        #{Category.count}"
puts "Posts:             #{Post.count}"
puts "Articles:          #{Article.count}"
puts "RgbColors:         #{RgbColor.count}"
puts "Colors:            #{Color.count}"
puts "InternalTagNames:  #{InternalTagName.count}"
puts "OptionTypes:       #{OptionType.count}"
puts "OptionValues:      #{OptionValue.count}"
puts "Products:          #{Product.count}"
puts "Variants:          #{Variant.count}"
puts "Tags:              #{Tag.count}"
puts "Taggings:          #{Tagging.count}"
puts '=' * 50
