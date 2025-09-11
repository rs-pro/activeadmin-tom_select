class Tagging < ApplicationRecord
  belongs_to :tag
  belongs_to :post

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at id post_id tag_id updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[post tag]
  end
end
