class Category < ApplicationRecord
  has_many :posts
  belongs_to :created_by, class_name: 'User', optional: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_by_id description id name created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[posts created_by]
  end
end
