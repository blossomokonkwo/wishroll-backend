class Roll < ApplicationRecord
  #Associations
  belongs_to :user, counter_cache: :roll_count
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :comments, foreign_key: :roll_id, dependent: :destroy
  has_many :views, as: :viewable, dependent: :destroy
  has_many :shares, as: :shareable, dependent: :destroy
  has_many :tags, foreign_key: :roll_id, dependent: :destroy
  has_one :location, as: :locateable, dependent: :destroy
  has_many :bookmarks, as: :bookmarkable, dependent: :destroy
  has_one_attached(:media_item)
  has_one_attached(:thumbnail_image)

  include IdentityCache
  cache_belongs_to :user
  cache_has_many :comments
  cache_has_many :views
  cache_has_many :tags

  #user interaction APIs
  def viewed?(user)
    Rails.cache.fetch("WishRoll:Cache:View:Viewer:#{user.id}:Viewed:#{self.uuid}") {
        self.views.find_by(user: user).present?
    }
  end

  def liked?(user)
    Rails.cache.fetch("WishRoll:Cache:Like:Liker:#{user.id}:Liked:#{self.uuid}") {
        self.likes.find_by(user: user).present?
    }
  end

  def bookmarked?(user)
    Rails.cache.fetch("WishRoll:Cache:Bookmark:Bookmarker:#{user.id}:Bookmarked:#{self.uuid}") {
        self.bookmarks.find_by(user: user).present?
    }
  end

  after_destroy do
    Activity.where(content_id: self.id, activity_type: self.class.name).destroy_all
  end

  after_create do
    user.touch
  end
  
end
