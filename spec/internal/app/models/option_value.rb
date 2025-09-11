class OptionValue < ApplicationRecord
  belongs_to :option_type
  has_many :variants
end
