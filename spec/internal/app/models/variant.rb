class Variant < ApplicationRecord
  belongs_to :product, optional: true
  belongs_to :option_value, optional: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[price product_id option_value_id id created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[product option_value]
  end
end
