class ChannelsController < ApplicationController
  before_filter :authenticate_user!, :only => [:create, :edit, :new]
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
    device_user_id = Device.find(@channel.device_id)

    @channel.device_user_id = device_user_id.device_id
    if not Channel.where(channel_id: @channel.channel_id, device_user_id: device_user_id).exists?
      @channel.save
    end

    device_id = @channel.device_id
    redirect_to front_show_device_path(device_id)
  end

  def update
    @channel.update(channel_params)
    device_id = @channel.device_id
    # respond_with(@channel)
    redirect_to front_show_device_path(device_id)
  end

  def destroy
    device_id = @channel.device_id
    @channel.destroy
    redirect_to front_show_device_path(device_id)
  end

  def receive_data
    device_id = params[:dev_id]
    user_id = params[:user]
    sign = params[:sign]

    data = params[:data]

    data_array = data.split('_')
    data_test = []
    if data_array
      data_array.each do |tp_data|
        data_content_array = tp_data.split('-')
        data_test << data_content_array[0]
        data_test << data_content_array[1]
        data_test << data_content_array[2]
        if data_content_array
          @channel = Channel.where(:channel_id => data_content_array[0], :device_user_id => device_id).first
          if @channel
            data_points = @channel.data_points ? @channel.data_points : ""
            data_points = data_points + "||" + data_content_array[1] + '-' + data_content_array[2]

            if data_points.split('||').length < 20
              # @channel.update_attribute(:data_points, data_points)
            else
            end
            @channel.update_attribute(:data_points, data_points)

            data_test << data_points
          end
        end
      end
      # ret = { :result => "0", :data_array => data_array, :data_test => data_test }
      ret = { :result => "0" }
      render json: ret.to_json
    else
      # ret = { :result => "-1", :data => data, :data_array => data_array }
      ret = { :result => "-1" }
      render json: ret.to_json  
    end
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
          # ret = { :result => "0", :message => "success. save data succeed!"} }
          ret = { :result => "0" }
          render json: ret.to_json
        else
          # ret = { :result => {:code => "-1", :message => "failed. save data failed!"}, :data => { } }
          ret = { :result => "1" }
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
