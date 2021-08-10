class MutualRelationship < ApplicationRecord
  belongs_to :user, counter_cache: :mutual_relationships_count
  belongs_to :mutual, class_name: "User", counter_cache: :mutual_relationships_count
  # validations
  validate :mutual_id_and_user_id_must_be_different

  def mutual_id_and_user_id_must_be_different    
    errors.add([:user_id, :mutual_id], "User id and mutual id must be different") if mutual_id == user_id
  end

  
  include IdentityCache
  cache_belongs_to :user
  cache_belongs_to :mutual
end
