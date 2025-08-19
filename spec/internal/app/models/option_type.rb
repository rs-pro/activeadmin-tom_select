class OptionType < ActiveRecord::Base
  has_many :option_values
  has_many :products
end