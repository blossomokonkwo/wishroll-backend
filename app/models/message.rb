class Message < ApplicationRecord
    has_one_attached :media_item
    belongs_to :chat_room, class_name: "ChatRoom", foreign_key: :chat_room_id
    belongs_to :user, -> {select([:username, :is_verified, :profile_picture_url, :id])}, class_name: "User", foreign_key: :sender_id
    validates :chat_room, presence: true
    validates :kind, presence: true, inclusion: {in: ["text", "emoji", "photo", "video", "audio"]}
end
