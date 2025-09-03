require 'database_cleaner-active_record'

class User < ActiveRecord::Base
  def self.ransackable_attributes(_auth_object = nil)
    %w[name email]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end

  def to_s
    name.presence || "User #{id}"
  end
end

class Category < ActiveRecord::Base
  belongs_to :created_by, class_name: 'User', optional: true

  def self.ransackable_attributes(_auth_object = nil)
    ['name']
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end

class Post < ActiveRecord::Base
  belongs_to :category, optional: true
  belongs_to :user, optional: true

  scope(:published, -> { where(published: true) })

  def self.ransackable_attributes(_auth_object = nil)
    %w[category_id title user_id]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end

module RGB
  class Color < ActiveRecord::Base
    self.table_name = :rgb_colors
    has_many :tags, class_name: 'Internal::TagName'
  end
end

module Internal
  class TagName < ActiveRecord::Base
    self.table_name = :internal_tag_names
    belongs_to :color, class_name: 'RGB::Color', foreign_key: :color_id, optional: true

    def self.ransackable_attributes(_auth_object = nil)
      ['color_id']
    end

    def self.ransackable_associations(_auth_object = nil)
      []
    end
  end
end

class OptionType < ActiveRecord::Base; end

class OptionValue < ActiveRecord::Base
  belongs_to :option_type, optional: true

  def self.ransackable_attributes(_auth_object = nil)
    ['value']
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end

class Product < ActiveRecord::Base
  belongs_to :option_type, optional: true
  has_many :variants
end

class Variant < ActiveRecord::Base
  belongs_to :product, optional: true
  belongs_to :option_value, optional: true
end

RSpec.configure do |config|
  config.after do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
  end
end
