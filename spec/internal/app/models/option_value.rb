class OptionValue < ActiveRecord::Base
  belongs_to :option_type
  has_many :variants
end