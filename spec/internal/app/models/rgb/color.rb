module RGB
  class Color < ActiveRecord::Base
    self.table_name = :rgb_colors
    has_many :tags, class_name: 'Internal::TagName'

    def self.ransackable_attributes(_auth_object = nil)
      %w[code description id created_at updated_at]
    end

    def self.ransackable_associations(_auth_object = nil)
      ['tags']
    end
  end
end
