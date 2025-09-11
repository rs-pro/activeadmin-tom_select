class Article < ApplicationRecord
  belongs_to :category, optional: true
  belongs_to :user, optional: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[category_id title]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
