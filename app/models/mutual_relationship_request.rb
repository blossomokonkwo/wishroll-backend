class MutualRelationshipRequest < ApplicationRecord
  belongs_to :requesting_user, class_name: "User", foreign_key: :requesting_user_id 
  belongs_to :requested_user, class_name: "User", foreign_key: :requested_user_id

  # Validations
  validate :requesting_user_id_and_requested_user_id_must_be_different

  def requesting_user_id_and_requested_user_id_must_be_different
    errors.add(:requesting_user, "Requesting User user must be different from requested user") if requesting_user == requested_user
  end
  
end
