class InternalTagName < ApplicationRecord
  belongs_to :color, class_name: 'RgbColor', optional: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[color_id id name created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    ['color']
  end
end
