class Product < ActiveRecord::Base
  belongs_to :option_type, optional: true
  has_many :variants

  def self.ransackable_attributes(_auth_object = nil)
    %w[name option_type_id id created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[option_type variants]
  end
end
