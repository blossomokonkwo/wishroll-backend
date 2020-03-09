class ChatRoom < ApplicationRecord
  belongs_to :topic, optional: true
  belongs_to :creator, class_name: "User", foreign_key: :creator_id
  has_many :chat_room_users
  has_many :users, through: :chat_room_users
  has_many :messages, dependent: :destroy
end
