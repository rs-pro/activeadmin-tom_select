class Tag < ApplicationRecord
  has_many :taggings
  has_many :posts, through: :taggings

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at id name updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[posts taggings]
  end
end
