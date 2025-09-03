class Category < ActiveRecord::Base
  has_many :posts
  belongs_to :created_by, class_name: 'User', optional: true

  def self.ransackable_attributes(auth_object = nil)
    ["created_by_id", "description", "id", "name", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["posts", "created_by"]
  end
end
