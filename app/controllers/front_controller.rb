class FrontController < ApplicationController
  before_filter :authenticate_user!, :only => [:profile, :new_device, :new_channel, :show_chart, :show_device, :edit_channel, :edit_device]
  layout 'appprofile', :only => [:profile, :new_device, :new_channel, :show_chart, :show_device, :edit_channel, :edit_device, :show_channel_chart]

  before_action :set_device, :set_channel, only: [:show_channel_chart]

  def index
  end

  def sdk
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
      ret = { :result => {:code => "0", :message => "success. create device succeed!"}, :data => { } }
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
      # @devices = Device.where(:user_id => current_user.id)

      @devices = current_user.devices
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
      # @data_points = @channel.data_points.to_s.split("||").map {|item| item.split('-')[0].to_i}
      # @data_points = data_filter(@channel.data_points.to_s)
      # time1 = Time.local(2015, 08, 10, 10, 13, 15)
      # time2 = Time.local(2015, 08, 10, 10, 13, 16)
      time = Time.now
      @date_points = [[time, 20], [time + 10, 30]]
    else
      @data_points = []
    end 
  end

  def show_device
    device_id = params[:id]
    @device = Device.where(:id => device_id).first
    @channels = Channel.where(:device_id => device_id).order("channel_id ASC")
  end

  def edit_device
    device_id = params[:id]
    @device = Device.where(:id => device_id).first
  end

  def get_cmdquery
    @ret = "get cmdquery"

    device_id = params[:device_id]
    @device = Device.find(device_id)
    channel_id = params[:channel_id]
    @channel = Channel.find(channel_id)
    @cmdquery = Cmdquery.where(channel_id: channel_id).last

    if @cmdquery
      @cmdquery.update_attributes( send_request_flag: 'Y')
    end

    if @device
      redirect_to front_show_device_path(@device) 
    else
      redirect_to front_profile_path
    end
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

    def data_filter(datapoints)
      datapoints_array = []
      if datapoints
        if datapoints.split("||").length > 1
          datapoints.split("||").each do |item|
            if item.split('-').length > 1
              data = []
              value = item.split('-')[0]
              data << get_date_time(item.split('-')[1])
              if value[0, 1] == 'N'
                # datapoints_array << first.sub(/[N]/, '-').to_i
                data << value.sub(/[N]/, '-').to_i
              else
                # datapoints_array << first.to_i
                data << value.to_i
              end
              datapoints_array << data
            end
          end
        end
      end
      datapoints_array
    end

    def get_date_time(date_str)
      date_array = date_str.scan(/\d{4}\d{2}\d{2}T\d{2}\d{2}\d{2}/)
      date = Time.local(date_array[0],date_array[1],date_array[2],date_array[3],date_array[4],date_array[5]).zone
      return date.to_i
    end
end
