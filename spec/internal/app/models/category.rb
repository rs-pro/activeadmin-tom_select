class Category < ActiveRecord::Base
  has_many :posts
  belongs_to :created_by, class_name: 'User', optional: true
end