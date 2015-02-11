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
end
