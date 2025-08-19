# Create sample users
users = []
10.times do |i|
  users << User.create!(name: "User #{i + 1}")
end

# Create sample categories
categories = []
5.times do |i|
  categories << Category.create!(
    name: "Category #{i + 1}",
    created_by: users.sample
  )
end

# Create sample posts
20.times do |i|
  Post.create!(
    title: "Post #{i + 1}",
    category: categories.sample,
    user: users.sample,
    published: [true, false].sample
  )
end

# Create RGB colors
colors = [
  { code: '#FF0000', description: 'Red' },
  { code: '#00FF00', description: 'Green' },
  { code: '#0000FF', description: 'Blue' },
  { code: '#FFFF00', description: 'Yellow' },
  { code: '#FF00FF', description: 'Magenta' },
  { code: '#00FFFF', description: 'Cyan' },
  { code: '#000000', description: 'Black' },
  { code: '#FFFFFF', description: 'White' }
]

rgb_colors = colors.map { |color| RgbColor.create!(color) }

# Create internal tag names
10.times do |i|
  InternalTagName.create!(
    name: "Tag #{i + 1}",
    description: "Description for tag #{i + 1}",
    color: rgb_colors.sample
  )
end

# Create option types and values
option_types = []
3.times do |i|
  option_type = OptionType.create!(name: "Option Type #{i + 1}")
  option_types << option_type

  5.times do |j|
    OptionValue.create!(
      value: "Value #{j + 1} for #{option_type.name}",
      option_type: option_type
    )
  end
end

# Create products and variants
10.times do |i|
  product = Product.create!(
    name: "Product #{i + 1}",
    option_type: option_types.sample
  )

  3.times do |j|
    Variant.create!(
      price: (10 + j) * 100,
      product: product,
      option_value: product.option_type&.option_values&.sample
    )
  end
end

puts 'Seed data created successfully!'
puts "Created #{User.count} users"
puts "Created #{Category.count} categories"
puts "Created #{Post.count} posts"
puts "Created #{RgbColor.count} RGB colors"
puts "Created #{InternalTagName.count} internal tag names"
puts "Created #{OptionType.count} option types"
puts "Created #{OptionValue.count} option values"
puts "Created #{Product.count} products"
puts "Created #{Variant.count} variants"
