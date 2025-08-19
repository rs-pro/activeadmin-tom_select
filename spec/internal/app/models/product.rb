class Product < ActiveRecord::Base
  belongs_to :option_type, optional: true
  has_many :variants
end