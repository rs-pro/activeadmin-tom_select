class InternalTagName < ActiveRecord::Base
  belongs_to :color, class_name: 'RgbColor', optional: true
end