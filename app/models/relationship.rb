class Relationship < ApplicationRecord
  include IdentityCache
  belongs_to :followed_user, class_name: "User", foreign_key: :followed_id, counter_cache: :followers_count, touch: true
  belongs_to :follower_user, class_name: "User", foreign_key: :follower_id, counter_cache: :following_count, touch: true
  cache_belongs_to :followed_user
  cache_belongs_to :follower_user

  after_destroy do
    #we want to flush the cache for the boolean value that determines whether a user is following another user 
    logger.debug {"[WishRoll Cache] delete succeeded for WishRoll:Cache:Relationship:Follower#{follower_user.id}:Following#{followed_user.id}"} if Rails.cache.delete("WishRoll:Cache:Relationship:Follower#{follower_user.id}:Following#{followed_user.id}")
    follower_user.touch; followed_user.touch
  end
  after_create do
    #after a relationship is created, we want to write a boolean value of true to cache which indicates that the following user is indeed following the followed user
    logger.debug {"[WishRoll Cache] write succeeded for WishRoll:Cache:Relationship:Follower#{follower_user.id}:Following#{followed_user.id}"} if Rails.cache.write("WishRoll:Cache:Relationship:Follower#{follower_user.id}:Following#{followed_user.id}", true)
    follower_user.touch; followed_user.touch
    unless Activity.find_by(active_user_id: follower_id, user_id: followed_id, activity_type: self.class.name)
      if followed_user.followers_count < 100
        Activity.create(content_id: id, active_user: follower_user, user: followed_user, activity_type: self.class.name, activity_phrase: "#{follower_user.username} began following you")
      elsif followed_user.followers_count == 101
        Activity.create(content_id: id, active_user: follower_user, user: followed_user, activity_type: self.class.name, activity_phrase: "you now have over one hundred followers")
      elsif followed_user.followers_count == 501
        Activity.create(content_id: id, active_user: follower_user, user: followed_user, activity_type: self.class.name, activity_phrase: "you now have over five hundred followers")
      elsif followed_user.followers_count == 1001
        Activity.create(content_id: id, active_user: follower_user, user: followed_user, activity_type: self.class.name, activity_phrase: "you now have over one thousand followers")
      elsif followed_user.followers_count == 2001
        Activity.create(content_id: id, active_user: follower_user, user: followed_user, activity_type: self.class.name, activity_phrase: "you now have over two thousand followers")
      elsif followed_user.followers_count == 3001
        Activity.create(content_id: id, active_user: follower_user, user: followed_user, activity_type: self.class.name, activity_phrase: "you now have over three thousand followers")
      elsif followed_user.followers_count == 4001
        Activity.create(content_id: id, active_user: follower_user, user: followed_user, activity_type: self.class.name, activity_phrase: "you now have over four thousand followers")
      elsif followed_user.followers_count == 5001
        Activity.create(content_id: id, active_user: follower_user, user: followed_user, activity_type: self.class.name, activity_phrase: "you now have over five thousand followers")
      elsif followed_user.followers_count == 6001
        Activity.create(content_id: id, active_user: follower_user, user: followed_user, activity_type: self.class.name, activity_phrase: "you now have over six thousand followers")
      elsif followed_user.followers_count == 7001
        Activity.create(content_id: id, active_user: follower_user, user: followed_user, activity_type: self.class.name, activity_phrase: "you now have over seven thousand followers")
      elsif followed_user.followers_count == 8001
        Activity.create(content_id: id, active_user: follower_user, user: followed_user, activity_type: self.class.name, activity_phrase: "you now have over eight thousand followers")
      elsif followed_user.followers_count == 9001
        Activity.create(content_id: id, active_user: follower_user, user: followed_user, activity_type: self.class.name, activity_phrase: "you now have over nine thousand followers")
      elsif followed_user.followers_count == 10001
        Activity.create(content_id: id, active_user: follower_user, user: followed_user, activity_type: self.class.name, activity_phrase: "you now have over ten thousand followers")
      elsif followed_user.followers_count == 15001
        Activity.create(content_id: id, active_user: follower_user, user: followed_user, activity_type: self.class.name, activity_phrase: "you now have over fifteen thousand followers")
      elsif followed_user.followers_count == 20001
        Activity.create(content_id: id, active_user: follower_user, user: followed_user, activity_type: self.class.name, activity_phrase: "you now have over twenty thousand followers")
      elsif followed_user.followers_count == 25001
        Activity.create(content_id: id, active_user: follower_user, user: followed_user, activity_type: self.class.name, activity_phrase: "you now have over twenty-five thousand followers")
      elsif followed_user.followers_count == 30001
        Activity.create(content_id: id, active_user: follower_user, user: followed_user, activity_type: self.class.name, activity_phrase: "you now have over thirty thousand followers")
      elsif followed_user.followers_count == 35001
        Activity.create(content_id: id, active_user: follower_user, user: followed_user, activity_type: self.class.name, activity_phrase: "you now have thirty-five thousand followers")
      elsif followed_user.followers_count == 40001
        Activity.create(content_id: id, active_user: follower_user, user: followed_user, activity_type: self.class.name, activity_phrase: "you now have over fourty thousand followers")
      elsif followed_user.followers_count == 45001
        Activity.create(content_id: id, active_user: follower_user, user: followed_user, activity_type: self.class.name, activity_phrase: "you now have over fourty-five thousand followers")
      elsif followed_user.followers_count == 50001
        Activity.create(content_id: id, active_user: follower_user, user: followed_user, activity_type: self.class.name, activity_phrase: "you now have over fifty thousand followers")
      end
    end
  end
end
