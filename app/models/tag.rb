class Tag < ApplicationRecord
    include PgSearch::Model
    include IdentityCache
    belongs_to :post
    validates :text, presence: true

    #search API's 
    pg_search_scope :search, against: :text, using: {tsearch: {dictionary: :english, normalization: 4, prefix: true, tsvector_column: :tsv_text}}, order_within_rank: "tags.created_at DESC"
    pg_search_scope :new_search, against: :text, using: {tsearch: {dictionary: :english, tsvector_column: :tsv_text, any_word: true, prefix: true}}, order_within_rank: "tags.created_at DESC"
    pg_search_scope :recommend, against: :text, using: {tsearch: {dictionary: :english, tsvector_column: :tsv_text, any_word: true}}, order_within_rank: "tags.created_at DESC"
    pg_search_scope :trending_tag, against: :text, using: {tsearch: {dictionary: :english, tsvector_column: :tsv_text, prefix: true}}, order_within_rank: "tags.created_at ASC"

    after_create do
        update(tsv_text: text)
    end

end
