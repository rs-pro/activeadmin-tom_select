class OptionValue < ApplicationRecord
  belongs_to :option_type
  has_many :variants

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at id name option_type_id updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
