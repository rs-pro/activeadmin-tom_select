class RgbColor < ActiveRecord::Base
  has_many :internal_tag_names, foreign_key: :color_id

  def display_name
    "#{code} - #{description}"
  end
end
