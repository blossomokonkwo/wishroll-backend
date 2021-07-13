json.id @board.id
json.uuid @board.uuid
json.name @board.name
json.description @board.description
json.is_featured @board.featured
json.created_at @board.created_at
json.updated_at @board.updated_at
json.member_count @board.board_member_count
json.avatar_url @board.avatar_url
json.banner_url @board.banner_url
json.is_member @board.member?(@current_user)
json.is_admin @board.admin?(@current_user)
json.board_members @board.users.limit(10) do |user|
    json.id user.id
    json.verified user.verified
    json.username user.username
    json.name user.name
    json.avatar_url user.avatar_url
end