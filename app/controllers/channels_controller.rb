class ChannelsController < ApplicationController
  before_action :set_channel, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @channels = Channel.all
    respond_with(@channels)
  end

  def show
    respond_with(@channel)
  end

  def new
    @channel = Channel.new
    respond_with(@channel)
  end

  def edit
  end

  def create
    @channel = Channel.new(channel_params)
    @channel.save

    device_id = @channel.device_id
    redirect_to front_show_device_path(device_id)
  end

  def update
    @channel.update(channel_params)
    respond_with(@channel)
  end

  def destroy
    @channel.destroy
    respond_with(@channel)
  end

  def send_data
    device_id = params[:dev_id]
    user_id = params[:user]
    channel = params[:channel]
    data_value = params[:value]
    timestamp = params[:timestamp]
    sign = params[:sign]

    # @device = Device.where(:device_id => device_id).first
    @device = Device.where(:device_id => device_id).first
    if not @device
      ret = { :result => {:code => "-1", :message => "failed. device not existed!"}, :data => { } }
      render json: ret.to_json
    end

    if @device
      @channel = Channel.where(:channel_id => channel, :device_id => @device.id).first
      if @channel
        data_points = @channel.data_points ? @channel.data_points : ""
        data_points = data_points + "||" + data_value

        if @channel.update_attribute(:data_points, data_points)
          ret = { :result => {:code => "0", :message => "success. save data succeed!"}, :data => @channel.data_points }
          render json: ret.to_json
        else
          ret = { :result => {:code => "-1", :message => "failed. save data failed!"}, :data => { } }
          render json: ret.to_json
        end
      end
    else      
      ret = { :result => {:code => "-1", :message => "failed. device not existed!"}, :data => { } }
      render json: ret.to_json
    end
  end

  private
    def set_channel
      @channel = Channel.find(params[:id])
    end

    def channel_params
      params.require(:channel).permit(:title, :channel_id, :channel_direct, :channel_type, :channel_name, :device_id, :user_id)
    end
end
