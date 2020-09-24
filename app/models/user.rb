class User < ApplicationRecord
    include PgSearch::Model
    include IdentityCache
    acts_as_reader
    has_secure_password
    validates :email, :uniqueness => {message: "The email you have entered is already taken"}, presence: {message: "Please enter an appropriate email address"}, format: { with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i, message: "Please enter an appropriate email address"}, on: [:create, :update]
    validates :username, uniqueness: true, presence: {message: "You must provide a valid username"}, format: {with: /([a-z0-9])*/, message: "Your username must be lowercase and can not include symbols"}, on: [:create, :update]
    validates :birth_date, presence: {message: "Please enter your birthdate"}
    validates :bio, length: {maximum: 100, too_long: "%{count} is the maximum amount of characters allowed"}
    has_one_attached(:avatar) #users can display an image or video as their profile avatar
    has_one_attached(:profile_background_media) #users can display a background image or video on their profile background 
    
    
    #Associations 
    enum gender: [:male, :female, :unspecified]
    has_one :location, as: :locateable, dependent: :destroy
    has_many :posts, -> {order(created_at: :desc)}, class_name: "Post", dependent: :destroy
    has_many :rolls, -> {order(created_at: :desc)}, class_name: "Roll", dependent: :destroy
    has_many :comments, class_name: "Comment", dependent: :destroy
    has_many :views, class_name: "View", foreign_key: :user_id, dependent: :destroy
    has_many :shares, class_name: "Share", foreign_key: :user_id, dependent: :destroy
    has_many :likes, class_name: "Like", foreign_key: :user_id, dependent: :destroy
    has_many :bookmarks, dependent: :destroy 
    has_many :albums, dependent: :destroy


    #cache API's 
    cache_index :username, unique: true
    cache_index :name

    #Returns all of the rolls that a user has viewed with a default limit of 25 seconds and no offset by default
    def viewed_rolls(limit: 25, offset: nil)
        if offset
            Roll.joins(:views).where(views: {user: self}).where('created_at < ?', offset).order(created_at: :desc).limit(limit)
        else
            Roll.joins(:views).where(views: {user: self}).order(created_at: :desc).limit(limit)
        end        
    end

    #Returns all of the posts that a user has viewed with a default limit of 25 records and no offset
    def viewed_posts(limit: 25, offset: nil)
        if offset
            Post.joins(:views).where(views: {user: self}).where('created_at < ?', offset).order(created_at: :desc).limit(limit)
        else
            Post.joins(:views).where(views: {user: self}).order(created_at: :desc).limit(limit)
        end 
    end

    def liked_posts(limit: 25, offset: nil)
        if offset
            Post.joins(:likes).order("likes.created_at DESC").where(likes: {user_id: self.id}).offset(offset).limit(limit)
        else
            Post.joins(:likes).order("likes.created_at DESC").where(likes: {user_id: self.id}).limit(limit)
        end
        
    end

    def liked_rolls(limit: 25, offset: nil, show_private_rolls: true)
        if offset
            if show_private_rolls
                Roll.joins(:likes).order("likes.created_at DESC").where(likes: {user: self}).includes([:user, :views, :likes]).offset(offset).limit(limit)
            else
                Roll.joins(:likes).order("likes.created_at DESC").where.not(private: false).where(likes: {user: self}).includes([:user, :views, :likes]).offset(offset).limit(limit)
            end
        else
            if show_private_rolls
                Roll.joins(:likes).order("likes.created_at DESC").where(likes: {user: self}).includes([:user, :views, :likes]).limit(limit)
            else
                Roll.joins(:likes).order("likes.created_at DESC").where.not(private: false).where(likes: {user: self}).includes([:user, :views, :likes]).limit(limit)
            end 
        end
    end
    

    def created_posts(limit: 25, offset: nil)
        if offset
            Post.where(user: self).order(created_at: :desc).offset(offset).limit(limit)
        else
            Post.where(user: self).order(created_at: :desc).limit(limit)
        end
    end

    def created_rolls(limit:, offset:)
        Roll.where(user: self).order(created_at: :desc).offset(offset || 0).limit(limit || 15) 
    end
    
    
    def bookmarked_posts(limit: 25, offset: nil)
        if offset
            Post.joins(:bookmarks).where(bookmarks: {user: self}).order(created_at: :desc).offset(offset).limit(limit)
        else
            Post.joins(:bookmarks).where(bookmarks: {user: self}).order(created_at: :desc).limit(limit)
        end
    end

    def bookmarked_rolls(limit: 25, offset: nil)
        if offset
            Roll.joins(:bookmarks).where(bookmarks: {user: self}).order(created_at: :desc).offset(offset).limit(limit)
        else
            Roll.joins(:bookmarks).where(bookmarks: {user: self}).order(created_at: :desc).limit(limit)
        end
    end
    
    

    #Determines if a user has viewed a specified content
    def has_viewed?(content)        
        View.fetch_by_viewable_and_user(content, self).exists?
    end

    #search apis
    pg_search_scope :search, against: {username: 'A', name: 'B'}, using: {tsearch: {prefix: true, any_word: true}}

    #Gender APIs
    def self.males(limit: 25, offset: nil)
        if offset
            User.where(gender: :male).where('created_at < ?', offset).limit(limit)
        else
            User.where(gender: :male).limit(limit)
        end
    end

    def self.females(limit: 25, offset: nil)
        if offset
            User.where(gender: :female).where('created_at < ?', offset).limit(limit)
        else
            User.where(gender: :female).limit(limit)
        end
    end

    def self.unspecified
        if offset
            User.where(gender: :unspecified).or(User.where(gender: nil)).where('created_at < ?', offset).limit(limit)
        else
            User.where(gender: :unspecified).or(User.where(gender: nil)).limit(limit)
        end
    end

    def male?
        gender == "male"
    end

    def female?
        gender == "female"
    end

    def unspecified?
        gender == "unspecified" or gender == nil
    end
    
    #The users age in years
    def age
        ((Time.zone.now - birth_date.to_time) / 1.year.seconds).floor
    end

    #Whether or not the user is an adult 
    def adult?
        age >= 18
    end

    #returns all of the posts that a user has shared
    def shared_posts(limit: 25, offset: nil)
        if offset
            Post.joins(:shares).where(shares: {user: self}).where('posts.created_at < ?', offset).order(created_at: :desc).limit(limit)
        else
            Post.joins(:shares).where(shares: {user: self}).order(created_at: :desc).limit(limit)
        end        
    end

    #returns all of the rolls that a user has shared 
    def shared_rolls(limit: 25, offset: nil)
        if offset
            Roll.joins(:shares).where(shares: {user: self}).where('rolls.created_at < ?', offset).order(created_at: :desc).limit(limit)
        else
            Roll.joins(:shares).where(shares: {user: self}).order(created_at: :desc).limit(limit)
        end
    end

    def shared?(content)
        Share.where(shareable: content, user: self).present?
    end
    

    def viewed_posts(limit: 25, offset: nil)
        if offset
            Post.joins(:views).where(views: {user: self}).where('posts.created_at < ?', offset).order(created_at: :desc).limit(limit)
        else
            Post.joins(:views).where(views: {user: self}).order(created_at: :desc).limit(limit)
        end        
    end
    
    def viewed_rolls(limit: 25, offset: nil)
        if offset
            Roll.joins(:views).where(views: {user: self}).where('rolls.created_at < ?', offset).order(created_at: :desc).limit(limit)
        else
            Roll.joins(:views).where(views: {user: self}).order(created_at: :desc).limit(limit)
        end 
    end
    
    def viewed?(content)
        View.where(viewable: content, user: self).present?
    end
    
    #location APIs
    def state
        location.region
    end

    alias :region :state

    def american?
        country == 'United States of America'
    end

    def country
        location.country_name if location
    end

    def city
        location.city if location
    end

    def continent
        location.continent if location
    end

    #a user can have many active relationships which relates a user to the account he / she follows through the Relationship model and the follower_id foreign key.
    has_many :active_relationships, -> {order(created_at: :desc, id: :desc)},class_name: "Relationship", foreign_key: :follower_id, dependent: :destroy

    #a user can have many passive relationships which relates a user to the accounts he / she follows through the Relationship model.
    has_many :passive_relationships, -> {order(created_at: :desc, id: :desc)}, class_name: "Relationship", foreign_key: :followed_id, dependent: :destroy 
    
    has_and_belongs_to_many :blocked_users, -> { select([:username, :id, :name, :verified, :avatar_url])}, class_name: "User", join_table: :block_relationships, foreign_key: :blocker_id, association_foreign_key: :blocked_id
    
    #the users that a specific user is currently following 
    has_many :followed_users, through: :active_relationships, source: :followed_user

    #the users that currently follow a specific user 
    has_many :follower_users, through: :passive_relationships, source: :follower_user

    #the activities that have happended to the user
    has_many :activities, -> {order(created_at: :desc)}, class_name: "Activity", foreign_key: :user_id, dependent: :destroy

    #the activities that a user has caused
    has_many :caused_activities, class_name: "Activity", foreign_key: :active_user_id

    scope :verified, -> { where(:verified => true)} #this scope returns all the verified users in the app

    #joins table that joins the chat room and user model. A ChatRoomUser model is a user that is a member of a particular chat room
    has_many :chat_room_users

    #all of the chat rooms that a user is a member of
    has_many :chat_rooms, through: :chat_room_users

    #all of the messages that a user has created
    has_many :messages, foreign_key: :sender_id

    #all of the topics that a user has created
    has_many :topics

    #all of the chat rooms that a user is responsible for creating 
    has_many :created_chatrooms, class_name: "ChatRoom", foreign_key: :creator_id

    #a user can have multiple devices
    has_many :devices, class_name: "Device", foreign_key: :user_id, dependent: :destroy
    
    #returns a users must current device
    has_one :current_device, -> {where(current_device: true).limit(1)}, class_name: "Device", foreign_key: :user_id, dependent: :destroy

    #user has many reported posts. We use this array of reported posts to filter content that the user doesn't want to view. This property also allows administrators
    #to discover posts that users are reporting and find out if this post needs to be deleted of the app
    has_many :reported_posts_relationships, -> {order "created_at DESC"}, class_name: "UserBlockedPost", foreign_key: :user_id, dependent: :destroy
    
    #all the posts that the user has reported/blocked
    has_many :reported_posts, through: :reported_posts_relationships, source: :post

    def reported?(post:)
        reported_posts.include?(post)
    end

    

    #cache methods

    def cached_reported_posts
        Rails.cache.fetch([self, "reported_posts"]) {reported_posts.to_a}
        #we convert the relation object to an array to make it clear that we are using a cached version of the reported_posts
        #remember to flush the cache when changing the data base schema
    end

    def blocked?(user)
        # Rails.cache.fetch("WishRoll:Cache:BlockRelationship:Blocker#{self.id}:Blocked#{user.id}") {self.blocked_users.include?(user)}
        blocked_users.include?(user)
    end

    def self.current_user(user_id)
        User.find(user_id)
    end

    def following?(user)
        Rails.cache.fetch("WishRoll:Cache:Relationship:Follower#{self.id}:Following#{user.id}"){
            followed_users.include?(user)
        }
    end
    
end
