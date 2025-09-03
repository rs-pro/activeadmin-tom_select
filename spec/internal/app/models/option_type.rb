class OptionType < ActiveRecord::Base
  has_many :option_values
  has_many :products

  def self.ransackable_attributes(_auth_object = nil)
    %w[name id created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[option_values products]
  end
end
