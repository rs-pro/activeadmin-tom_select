module Internal
  class TagName < ActiveRecord::Base
    self.table_name = :internal_tag_names
    belongs_to :color, class_name: 'RgbColor', foreign_key: :color_id, optional: true

    def self.ransackable_attributes(_auth_object = nil)
      ['color_id']
    end

    def self.ransackable_associations(_auth_object = nil)
      []
    end
  end
end
