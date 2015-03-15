class FrontController < ApplicationController
  before_filter :authenticate_user!, :only => [:profile, :new_device, :new_channel, :show_chart]
  layout 'appprofile', :only => [:profile, :new_device, :new_channel, :show_chart]
  def index
  end

  def get_dcevice

  end

  def devices_create

  end

  def channels_create

  end

  def get_info
    @post_data = '{"data":{"dev_id":"9696969679","channeldata":[{"channel":"1","timestamp":"2012-03-15T16:13:14P123","value":"294.34"},{"channel":"2","timestamp":"2012-03-15T16:13:14P123","value":"294.34"}],"sign":"uioiuoiwurknsnflwekjfweifeuwfw"}}'.length
  end

  def post_info
    device_id = params(:device_id)
    @device = Device.new
    @device[:device_id] = device_id

    if @device.save
      ret = { :result => {:code => "2", :message => "success. create device succeed!"}, :data => { } }
      render json: ret.to_json    
    end
  end

  def admin
    render :layout => false
  end

  def profile
    if current_user
      # @current_user_id = current_user.id
      @devices = Device.where(:user_id => current_user.id)
    end
  end

  def new_device
  end

  def new_channel
    @channel = Channel.new
    @devices = Device.where(:user_id => current_user.id)
  end

  def show_chart

  end
end
