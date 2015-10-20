class Mobile::FrontController < Mobile::ApplicationController
  protect_from_forgery :except => :testpost
  skip_before_filter :verify_authenticity_token, only: [:testpost]

  before_filter :set_user, only: [:create_device]

  def index
    render text: 'Hello'
  end

  def post
    data = params[:data]
    random = SecureRandom.hex
    ret = {data: data, random: random}
    render json: ret.to_json
  end

  def datetime
    datetime = DateTime.now
    render json: {datetime: datetime}
  end

  def testpost
    data = params[:data]
    render json: { data: data }
  end

  # def test_device
  #   result_code = 0
  #   user = User.where(:email => '20121020@163.com').first
  #   devices = user.devices
  #   ret = "{devices:["
  #   if devices and devices.length > 0
  #     devices.each do |device|
  #       temp = "{id:'" + device.id + "',dev_id:'" + device.device_id + "',name:'" + device.device_name + "',description:'" + device.device_description + "',created_date:'" + device.created_at.to_s + "'},"
  #       ret += temp
  #     end
  #     # ret = ret.chop
  #     ret += "]}"
  #     puts ret
  #   else
  #     ret = "{devices:[]}"
  #   end
  #   key = '7e28692d005a1e39'
  #   encrypt_ret  = XXTEA.get_encrypt_str(ret.to_s, key)

  #   point = Point.first
  #   origin_value = point.value
  #   point_value = point.apply_expression

  #   ret = { ret: ret, encrypt_ret: encrypt_ret, origin_value: origin_value, point_value: point_value } 

  #   render json: ret.to_json
  # end

  def create_user
    data = params[:data]
    if data.length > 10
      raw_data = XXTEA.get_decrypt_str(data, PASSWORD_SALT)
      raw_hash = get_params(raw_data)
      username = raw_hash['username']
      password = raw_hash['password']
      user = User.new(email: username, password: "12345678")
    end
    
    if user and user.save      
      new_token = Devise.friendly_token
      user.update_attributes(encrypted_password: password, app_token: new_token)
      key = password[-16, 16]
      ret = "{message:'Succeed! Create User!',username:" + username + ",session:" + user.app_token.to_s + "}"
      result = XXTEA.get_encrypt_str(ret.to_s, key)
      render json: {result: 0, data: result}
    else
      ret = "{message:'Failed! Create User failed!',username:" + username + "}"
      result = XXTEA.get_encrypt_str(ret.to_s, PASSWORD_SALT)
      render json: {result: 1, data: result}
    end
  end

  def signin_user
    data = params[:data]

    if data.length > 10
      raw_data = XXTEA.get_decrypt_str(data, PASSWORD_SALT)
      puts "raw_data: " + raw_data
      raw_hash = get_params(raw_data)#Apiv10::Util::get_params(raw_data)
      puts "raw_hash: " + raw_hash.to_s
      # username = "iot5@test.com"#raw_hash[:username]
      # password = "22843f1858e944297e28692d005a1e39"#raw_hash[:password]
      username = raw_hash['username']
      password = raw_hash['password']
      user = User.where(email: username, encrypted_password: password).first
    end    

    if user
      result_code = 0
      new_token = Devise.friendly_token
      user.update_attributes(app_token: new_token)
      key = password[-16, 16]
      ret = "{message:'Succeed! Login User!',username:" + username + ",session:" + user.app_token.to_s + "}"
      result = XXTEA.get_encrypt_str(ret.strip, key)
      render json: {result: result_code, data: result}
    else
      result_code = 1
      ret = "{message:'Failed! Username password not valid!'}"
      result = XXTEA.get_encrypt_str(ret.to_s, PASSWORD_SALT)
      render json: {result: result_code, data: result}
    end
  end

  def device
    data = params[:data]
    session = params[:session]    
    result_code = 1
    result = ''

    begin
      if data.length > 10 and session
        user = User.where(app_token: session).first
        if user
          key = user.encrypted_password[-16, 16]
          raw_data = XXTEA.get_decrypt_str(data, key)
          raw_hash = get_params(raw_data)
          query_type = raw_hash['type']
          username = raw_hash['username']
          my_log = Logger.new("#{RAILS_ROOT}/log/prod_01.log")
          if username == user.email
            if query_type
              if query_type == 'device_key'
                result_code = 0
                ret = "{device_key:" + user.devices_key + "}"
                result = XXTEA.get_encrypt_str(ret.to_s, key)
              end
              if query_type == 'device_id'
                result_code = 0
                devices = user.devices
                ret = "{devices:["
                if devices and devices.count > 0 
                  devices.each do |device|
                    temp = "{id:'" + device.id + "',dev_id:'" + device.device_id + "',name:'" + device.device_name + "',description:'" + device.device_description + "',created_date:'" + device.created_at.to_s + "'},"
                    ret += temp
                  end
                  ret = ret.chop
                  ret += "]}"
                  my_log.info(ret)
                  # puts ret
                else
                  ret = "{devices:[]}"
                end
              end
              if query_type == 'channel_id'
                device_id = raw_hash['device_id']
                device = Device.find(device_id) if device_id
                if device
                  result_code = 0
                  ret = "{channels:["
                  channels = device.channels
                  if channels and channels.length > 0
                    channels.each do |channel|
                      temp = "{id:'" + channel.id + "',channel_id:'" + channel.channel_id.to_s + "',name:'" + channel.channel_name + "',type:'" + channel.channel_type + "',direction:'" + channel.channel_direct + "'},"
                      ret += temp
                    end
                    ret = ret.chop
                    ret += "]}"
                  else
                    ret = "{channels:[]}"
                  end
                end
              end
              if query_type == 'points'
                channel_id = raw_hash['channel_id'] 
                channel = Channel.find(channel_id) if channel_id
                if channel
                  result_code = 0
                  datapoints = channel.get_mobile_points.to_s
                  ret = "{datapoints: " + datapoints + "}"
                else
                  ret = "{datapoints: []}"
                end
              end
              if query_type == 'cmd'
                channel_id = raw_hash['channel_id']
                cmd_value = raw_hash['value']
                channel = Channel.find(channel_id) if channel_id
                if channel
                  result_code = 0
                  @cpanel_cmdquery = Cmdquery.new
                  @cpanel_cmdquery.send_flag = 'N'
                  @cpanel_cmdquery.value = cmd_value.to_s
                  @cpanel_cmdquery.channel_id = channel_id
                  @cpanel_cmdquery.channel_user_id = channel.channel_id
                  @cpanel_cmdquery.device_id = channel.device_id
                  @cpanel_cmdquery.save
                  ret = "{id: " + channel_id + ",cmd_value: " + cmd_value + "}"
                else
                  ret = "{data: []}"
                end
              end
              if query_type == 'seg'
                channel_id = raw_hash['channel_id']
                start_time = raw_hash['start']
                end_time = raw_hash['end']
                channel = Channel.find(channel_id) if channel_id
                if channel
                  result = 0
                  datapoints = channel.point.seg(start_time, end_time).map { | item | [item.date_int, item.value.sub(/[N]/, '-')] }
                  ret = "{datapoints: " + datapoints + "}"
                else
                  ret = "{datapoints: []}"
                end
              end
            end
            result = XXTEA.get_encrypt_str(ret.to_s, key)
            my_log.info(result)
          end
        end
      else
        result_code = 1
      end
    rescue
      result = 'Error!'
    end
    render json: {result: result_code, data: result}
  end

  def create_device
    result_code = 1
    result = ''

    if @user
      ret = ""
      raw_hash = get_raw_hash
      device_id = raw_hash['device_id']
      device = Device.where(:device_id => device_id).first if device_id
      if device
        channel_id = raw_hash['channel_id']
        channel = Channel.where(:channel_id => channel_id).first if channel_id
        if not channel
          tChannel = Channle.build(:device_id => device_id, :channel_id => channel_id)
          if tChannel.save
            result_code = 0
            ret = "{message:'Succeed! Create channel!',channel_id:" + channel_id + ",id:" + tChannel.id + "}"
          end
        end
      else
        tDevice = Device.build(:device_id => device_id)
        if tDevice.save
          result_code = 0
          ret = "{message:'Succeed! Create device!',device_id:" + device_id + ",id:" + tDevice.id + "}"
        end
      end
      result = get_encrypt_str(ret.to_s)
    end    
    render json: {result: result_code, data: result}
  end

  private
    def get_params(data)
      url_params = {}

      begin
        data.split( /&/ ).inject( Hash.new { | h, k | h[k]='' } ) do | h, s |
          k, v = s.split( /=/ )
          h[k] << v
          url_params = h
        end        
      rescue Exception => e
        url_params
      end
    end

    def set_user
      @data = params[:data]
      session = params[:session]    

      if @data.length > 10 and session
        @user = User.where(app_token: session).first
      end
    end

    def get_raw_hash
      raw_hash = {}
      if @user
        key = @user.encrypted_password[-16, 16]
        raw_data = XXTEA.get_decrypt_str(@data, key)
        raw_hash = get_params(raw_data)
      end
      return raw_hash
    end

    def get_encrypt_str(string)
      key = get_encrypt_key
      return result = XXTEA.get_encrypt_str(string.to_s, key)
    end

    def get_encrypt_key
      return @user.encrypted_password[-16, 16]
    end
end