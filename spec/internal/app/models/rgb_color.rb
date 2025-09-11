class RgbColor < ApplicationRecord
  has_many :internal_tag_names, foreign_key: :color_id
  has_many :tags, class_name: 'Internal::TagName', foreign_key: :color_id

  def display_name
    "#{code} - #{description}"
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[code description id created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[internal_tag_names tags]
  end
end
