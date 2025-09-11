class Color < ApplicationRecord
  def display_name
    "#{name} (#{hex})"
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at hex id name updated_at]
  end
end
