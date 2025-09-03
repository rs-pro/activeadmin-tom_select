class RgbColor < ActiveRecord::Base
  has_many :internal_tag_names, foreign_key: :color_id

  def display_name
    "#{code} - #{description}"
  end

  def self.ransackable_attributes(auth_object = nil)
    ["code", "description", "id", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["internal_tag_names"]
  end
end
