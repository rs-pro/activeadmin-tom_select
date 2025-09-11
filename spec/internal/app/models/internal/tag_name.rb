module Internal
  class TagName < ApplicationRecord
    self.table_name = :internal_tag_names
    belongs_to :color, class_name: 'RgbColor', foreign_key: :color_id, optional: true

    def self.ransackable_attributes(_auth_object = nil)
      %w[color_id name]
    end

    def self.ransackable_associations(_auth_object = nil)
      ['color']
    end
  end
end
