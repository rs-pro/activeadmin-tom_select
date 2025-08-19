class User < ActiveRecord::Base
  has_many :posts
  has_many :created_categories, class_name: 'Category', foreign_key: 'created_by_id'
end
