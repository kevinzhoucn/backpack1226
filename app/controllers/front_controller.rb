class FrontController < ApplicationController
  before_filter :authenticate_user!, :only => [:profile, :new_device, :new_channel, :show_chart, :show_device, :edit_channel, :edit_device]
  layout 'appprofile', :only => [:profile, :new_device, :new_channel, :show_chart, :show_device, :edit_channel, :edit_device, :show_channel_chart]

  before_action :set_device, only: [:show_channel_chart]
  before_action :set_channel, only: [:show_channel_chart]

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
    @device = Device.where(:device_id => "device01").first
    # @device = Device.where(:device_id => "1234567").first
    # @data_points = @device.device_data
    render :layout => false
  end

  def profile
    if current_user
      # @current_user_id = current_user.id
      @devices = Device.where(:user_id => current_user.id)
      # device = @devices.first
      # if device
      #   @channels = Channel.where(:device_id => device.id)
      # end
    end
  end

  def new_device
    @device = Device.new
  end

  def new_channel
    device_id = params[:device_id]
    @channel = Channel.new
    @devices = Device.where(:user_id => current_user.id)

    if device_id
      @device = Device.where(:id => device_id).first
    end
  end

  def edit_channel
    device_id = params[:device_id]
    channel_id = params[:channel_id]
    @device = Device.where(:id => device_id).first
    @channel = Channel.where(:id => channel_id ).first
  end

  def show_chart
    device_id = params[:id]
    if device_id 
      @device = Device.where(:id => device_id).first
    else
      @device = Device.where(:user_id => current_user.id).first
    end
    @channels = Channel.where(:device_id => @device.id)
    @channel = Channel.where(:device_id => @device.id).first

    if @channel
      @data_points = @channel.data_points.to_s.split("||").map {|item| item.to_i}
    end
  end

  def show_channel_chart
    @channels = Channel.where(:device_id => @device.id)
    if @channel
      @data_points = @channel.data_points.to_s.split("||").map {|item| item.to_i}
    else
      @data_points =[]
    end 
  end

  def show_device
    device_id = params[:id]
    @device = Device.where(:id => device_id).first
    @channels = Channel.where(:device_id => device_id)
  end

  def edit_device
    device_id = params[:id]
    @device = Device.where(:id => device_id).first
  end

  private 
    def set_device
      @device = Device.find(params[:id])
      if @device.nil?
        @device = Device.where(:user_id => current_user.id).first
      end
    end

    def set_channel
      @channel = Channel.find(params[:cid])
    end
end
