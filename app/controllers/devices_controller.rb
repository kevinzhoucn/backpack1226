class DevicesController < ApplicationController
  protect_from_forgery :except => [:webCreate, :postDatapoint]

  before_action :set_device, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @devices = Device.all.recent
    respond_with(@devices)
  end

  def show
    respond_with(@device)
  end

  def new
    @device = Device.new
    respond_with(@device)
  end

  def edit
  end

  def create
    @device = Device.new(device_params2)

    if current_user
      @device.user_id = current_user.id
    end

    @device.save
    redirect_to front_profile_path
    
    # if Device.where(:device_id => @device[:device_name]).exists?
    #   ret = { :result => {:code => "1", :message => "Already existed device!"}, :data => { } }
    #   render json: ret.to_json
    # else
    #   if @device.save
    #     ret = { :result => {:code => "2", :message => "success. create device succeed!"}, :data => { } }
    #     render json: ret.to_json      
    #   else
    #     ret = { :result => {:code => "0", :message => "success. create user failed!"}, :data => { } }
    #     render json: ret.to_json
    #   end
    # end
    #respond_with(@device)
  end

  def getDevice
    device_id = params[:dev_id]
    @device = Device.where(:device_id => device_id).first
    
    if @device
      ret = { :result => {:code => "1", :message => "success. device exist!"}, :data => { } }
    else
      ret = { :result => {:code => "0", :message => "success. device not exist!"}, :data => { } }
    end

    render json: ret.to_json
  end

  def getChannel
    device_id = params[:dev_id]
    channel_id = params[:channel]

    @device = Device.where(:device_id => device_id).first
    
    if @device
      ret = { :result => {:code => "1", :message => "success. channel exist!"}, :data => { :inout => "input", :datatype => "stream" } }
    else
      ret = { :result => {:code => "0", :message => "success. channel not exist!"}, :data => { } }
    end

    render json: ret.to_json
  end

  def postDatapoint
    #{"data":{"dev_id":"9696969679","channeldata":{"channel":"1"},"sign":"uioiuoiwurknsnflwekjfweifeuwfw"}}
    # device_pair = params.require(:data).permit(:dev_id, :channeldata)
    device_pair = params[:data]
    device_id = device_pair[:dev_id]
    channel_data = device_pair[:channeldata]

    @device = Device.where(:device_id => device_id).first
    @device[:device_data] = channel_data
    if @device.save
      ret = { :result => {:code => "1", :message => "success. received data succeed!"}, :data => { :content => device_pair } }
    else
      ret = { :result => {:code => "-1", :message => "fail. received data failed!"}, :data => { } }
    end
    # ret = { :result => {:code => "-1", :message => "fail. received data failed!"}, :data => { :data => channel_data } }
    render json: ret.to_json
  end

  def datetime
    date_time = DateTime.now
    ret = { :result => {:code => "1", :message => "success."}, :data => { :datetime => date_time} }
    render json: ret.to_json
  end

  def webCreate
    # device_id = params(device_params)
    device_pair = params.require(:data).permit(:device_id, :device_name, :device_description, :device_model_id, :device_model_key, :device_model_name, :device_model_description, :device_location_local, :device_location_latitude, :device_location_longitude, :device_uid)
    # device_pair = params(device_params)

    @device = Device.new(device_pair)

    if @device.save
      ret = { :result => {:code => "2", :message => "success. create device succeed!"}, :data => { } }
      render json: ret.to_json    
    end    
  end

  def channel
    device_id = params[:dev_id]
    user_id = params[:user]
    channel = params[:channel]
    data_value = params[:value]
    timestamp = params[:timestamp]
    sign = params[:sign]

    # @device = Device.where(:device_id => device_id).first
    @device = Device.where(:device_id => "device01").first
    if not @device
      @device = Device.create(:device_id => "device01")
      @device.save
    end
    if @device
      data_points = @device.device_data ? @device.device_data : ""
      data_points = data_points + "||" + data_value

      if @device.update_attribute(:device_data, data_points)
        ret = { :result => {:code => "2", :message => "success. save data succeed!"}, :data => { } }
        render json: ret.to_json
      else
        ret = { :result => {:code => "-1", :message => "failed. save data failed!"}, :data => { } }
        render json: ret.to_json
      end
    else      
      ret = { :result => {:code => "-1", :message => "failed. device not existed!"}, :data => { } }
      render json: ret.to_json
    end
  end

  def update
    @device.update(device_params)
    respond_with(@device)
  end

  def destroy
    @device.destroy
    redirect_to front_profile_path
  end

  private
    def set_device
      @device = Device.find(params[:id])
    end

    def device_params
      params.require(:data).permit(:device_id, :device_name, :device_description, :device_model_id, :device_model_key, :device_model_name, :device_model_description, :device_location_local, :device_location_latitude, :device_location_longitude, :device_uid)
    end

    def device_params2
      params.require(:device).permit(:device_id, :device_name, :device_description, :device_model_id, :device_model_key, :device_model_name, :device_model_description, :device_location_local, :device_location_latitude, :device_location_longitude, :device_uid)
    end
end