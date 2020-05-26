class ActivityNotificationJob < ApplicationJob  
    queue_as :notifications
    def perform(activity_id)
        activity = Activity.find(activity_id)
        if activity
            user = User.find(activity.user_id)
            n = Rpush::Apns::Notification.new
            n.app = Rpush::Client::ActiveRecord::App.find_by_name("wishroll-ios")
            if user.current_device
                n.device_token = user.current_device.device_token
                if activity.activity_type == "Comment"
                    comment_body = Comment.find(activity.content_id).body
                    n.alert = "#{activity.activity_phrase}: #{comment_body}"
                elsif activity.activity_type == "Post" or activity.activity_type == "Roll"
                    n.alert = "#{activity.activity_phrase} 💕\n#{activity.media_url}"
                else
                    n.alert = "#{activity.activity_phrase}"
                end
                n.sound = 'sosumi.aiff'
                n.data = {}
                n.save!
            end
        end        
    end
end