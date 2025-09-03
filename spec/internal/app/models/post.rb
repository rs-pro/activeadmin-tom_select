class Post < ActiveRecord::Base
  belongs_to :category, optional: true
  belongs_to :user, optional: true

  scope :published, -> { where(published: true) }
  scope :unpublished, -> { where(published: false) }

  def self.ransackable_attributes(_auth_object = nil)
    %w[body category_id id published title user_id created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[category user]
  end
end
