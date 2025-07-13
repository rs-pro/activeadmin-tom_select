class Post < ApplicationRecord
  belongs_to :user
  
  def self.ransackable_attributes(auth_object = nil)
    ["title", "content", "user_id"]
  end
  
  def self.ransackable_associations(auth_object = nil)
    ["user"]
  end
end
