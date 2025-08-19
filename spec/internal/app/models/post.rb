class Post < ActiveRecord::Base
  belongs_to :category, optional: true
  belongs_to :user, optional: true
  
  scope :published, -> { where(published: true) }
  scope :unpublished, -> { where(published: false) }
end