class Share < ApplicationRecord
  #associations
  belongs_to :user
  belongs_to :shareable, polymorphic: true, counter_cache: :share_count, touch: true
  has_one :location, as: :locatable, dependent: :destroy
  enum shared_service: [:library, :instagram, :snapchat, :tik_tok, :imessage, :twitter, :facebook, :tinder, :reddit, :messenger, :whatsapp, :email, :drop_box]
end
