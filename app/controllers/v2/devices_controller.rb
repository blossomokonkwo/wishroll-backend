class DevicesController < ApplicationController
    before_action :authorize_by_access_header!
    def create
        #first search for a device based on the unique device token
        @user = User.find(params[:user_id])
        @device = @user.device.create(device_token: params[:device_token], platform: params["platform"])
        if @device
        render json: nil, status: 201
        else
            render text: "This device has already been created", status: 500
        end
    end
        
end
