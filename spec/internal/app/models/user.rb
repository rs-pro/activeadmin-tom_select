class User < ActiveRecord::Base
  has_many :posts
  has_many :created_categories, class_name: 'Category', foreign_key: 'created_by_id'

  def self.ransackable_attributes(_auth_object = nil)
    %w[email id name created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[posts created_categories]
  end
end
