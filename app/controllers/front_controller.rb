class FrontController < ApplicationController
  def index
  end

  def get_dcevice

  end

  def devices_create

  end

  def channels_create

  end

  def get_info
    @post_data = '{"data":{"device_id":"98989898879"}}'
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
end
