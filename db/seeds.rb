# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'
# 1000.times do
#     User.create(email: Faker::Internet.free_email,username: Faker::Internet.username(3),password: Faker::Internet.password(min_length: 8), name: Faker::Name.name, birth_date: Faker::Date::birthday(min_age: 12), verified: false)
# end
# 10_000.times do
#    Post.create(user_id: Faker::Number.between(from: 1, to: 1000), view_count: Faker::Number.within(range: 0...30000), caption: Faker::Lorem.sentence, media_url: "http://192.168.1.164:3000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBPZz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--4658ff4ebb58cb53f2d0643d6e79d22df2a8775d/24ACA6A9-DFC1-4AEF-B2E8-C4A320C6B498.mp4", thumbnail_url: "http://192.168.1.164:3000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBPdz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--f1f329e20e7be8a0a9c51c5563af84fbad4cdf1c/FD615812-539B-489B-927A-5B69BCCDEB83.jpeg")
# end
100_000.times do 
    Comment.create(user_id: Faker::Number.between(from: 1, to: 10_000), body: Faker::Lorem.sentence, post_id: Faker::Number.within(range: 3...9605), original_comment_id: nil)
end
# 5_000.times do 
#     num = Random.new.rand(1..2)
#     likeable_type = nil
#     case num
#     when 1
#         likeable_type = "Post"
#     when 2
#         likeable_type = "Comment"
#     end
#     Like.create likeable_type: "Post", likeable_id: Faker::Number.between(from: 1, to: 25000), user_id: Faker::Number.between(from: 1, to: 30000)
# end
100_000.times do 
    Tag.create(post_id: Faker::Number.between(from: 3, to: 10_000), text: Faker::Game.title)
end
# 1000.times do
#     Topic.create title: Faker::Book.title, user_id: Faker::Number.between(from: 1, to: 30000), hot_topic: Random.new.rand(0..75) == 3 ? true : false
# end
# 10000.times do
#     ChatRoom.create topic_id:  Random.new.rand(0..50) == 3 ? Faker::Number.within(range: 1...990) : nil, creator_id: Faker::Number.between(from: 1, to: 30000), name: Random.new.rand(0..100) == 3 ? Faker::Book.title : nil
# end
# 10000.times do
#     ChatRoomUser.create user_id: Faker::Number.between(from: 1, to: 30000), chat_room_id: Faker::Number.between(from: 1, to: 10000)
# end
# 50000.times do
#     Message.create sender_id: Faker::Number.between(from: 1, to: 30000), chat_room_id: Faker::Number.between(from: 1, to: 10000), kind: "text", body: Faker::Lorem.sentence 
# end
# 15000.times do
#     Relationship.create follower_id: Faker::Number.between(from: 1, to: 30000), followed_id: Faker::Number.between(from: 1, to: 30000)
# end
# Post.all.find_each do |post|
#     post.posts_media_url = Post.last.posts_media_url
#     post.save
# end
# 10.times do 
#     Board.create(name: Faker::Movie.title, description: Faker::Movie.quote, featured: true)
# end

# 200.times do 
#     BoardMember.create(board_id: Faker::Number.between(from: 11, to: 26), user_id: Faker::Number.between(from: 1, to: 959), is_admin: Faker::Number.between(from: 1, to: 100) == 10)
# end
# Board.find_each do |board|
#     board.board_members.create(user: User.fetch(3))
# end
#there are 7,238 seeded users 
#there are 100,000 seeded comments with the first 100 posts having a dispropotionate ammount of comments at 50,000. This disproportionality models how social networks handle the traffic with more engaging posts.
#there are 100,000 likes with the first 100 comments or posts having the majority of likes at 50_000 likes
#there are 10_000 relationships with users with the first ten users having a disproportionate amount of the followers at 5000
#user with id 2 is following 10000 other users. This simulates when a user is following alot of other users.a
