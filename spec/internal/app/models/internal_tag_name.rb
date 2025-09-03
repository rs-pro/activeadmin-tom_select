class InternalTagName < ActiveRecord::Base
  belongs_to :color, class_name: 'RgbColor', optional: true

  def self.ransackable_attributes(auth_object = nil)
    ["color_id", "id", "name", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["color"]
  end
end
