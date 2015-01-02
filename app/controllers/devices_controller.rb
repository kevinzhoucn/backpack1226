class DevicesController < ApplicationController
  before_action :set_device, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @devices = Device.all
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
    @device = Device.new(device_params)
    if Device.where(:device_id => @device[:device_name]).exists?
      ret = { :result => {:code => "1", :message => "Already existed device!"}, :data => { } }
      render json: ret.to_json
    else
      if @device.save
        ret = { :result => {:code => "2", :message => "success. create device succeed!"}, :data => { } }
        render json: ret.to_json      
      else
        ret = { :result => {:code => "0", :message => "success. create user failed!"}, :data => { } }
        render json: ret.to_json
      end
    end
    #respond_with(@device)
  end

  def update
    @device.update(device_params)
    respond_with(@device)
  end

  def destroy
    @device.destroy
    respond_with(@device)
  end

  private
    def set_device
      @device = Device.find(params[:id])
    end

    def device_params
      params.require(:data).permit(:device_id, :device_name, :device_description, :device_model_id, :device_model_key, :device_model_name, :device_model_description, :device_location_local, :device_location_latitude, :device_location_longitude, :device_uid)
    end
end
