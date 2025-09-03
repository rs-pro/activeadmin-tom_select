class User < ActiveRecord::Base
  has_many :posts
  has_many :created_categories, class_name: 'Category', foreign_key: 'created_by_id'

  def self.ransackable_attributes(auth_object = nil)
    ["email", "id", "name", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["posts", "created_categories"]
  end
end
