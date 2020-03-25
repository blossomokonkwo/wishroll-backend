class MessageNotificationWorker
    require 'houston'
    include Sidekiq::Worker
    sidekiq_options queue: "notifications"
    def perform(message_id)
        @message = Message.find(message_id)
        @user = @message.user
        token = @user.device.device_token
        notification = Houston::Notification.new(device: token)
        if @message.media_url
            notification.alert = "#{@user.username}: #{@message.media_url}"
        else
            notification.alert = "#{@user.username} said #{@message.body}"
        end
        notification.badge = 1
        notification.sound = 'sosumi.aiff'        
        APN.push(notification)
    end
    
end