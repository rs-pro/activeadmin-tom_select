class User < ApplicationRecord
  has_many :posts
  
  def display_name
    "#{name} (#{email})"
  end
  
  def self.ransackable_attributes(auth_object = nil)
    ["name", "email", "department"]
  end
  
  def self.ransackable_associations(auth_object = nil)
    ["posts"]
  end
end
