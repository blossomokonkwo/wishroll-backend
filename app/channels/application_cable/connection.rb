module ApplicationCable
  class Connection < ActionCable::Connection::Base
    include JWTSessions::RailsAuthorization   
    identified_by :current_user
    def connect
       current_user = get_current_user
    end

    def disconnect
      
    end
    
    private 
    def get_current_user
      #get the current user else reject the unathourized connection
      begin
        return User.find(payload["user_id"])
      rescue => exception
        reject_unauthorized_connection
      end
    end
  end
end
