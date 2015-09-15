class Mobile::FrontController < Mobile::ApplicationController
  protect_from_forgery :except => :testpost
  skip_before_filter :verify_authenticity_token, only: [:testpost]

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

    if data.length > 10 and session
      user = User.where(app_token: session).first
      if user
        key = user.encrypted_password[-16, 16]
        raw_data = XXTEA.get_decrypt_str(data, key)
        raw_hash = get_params(raw_data)
        query_type = raw_hash['type']
        username = raw_hash['username']
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
              if devices and devices.length > 0
                devices.each do |device|
                  temp = "{id:" + device.id + "},"
                  ret += temp
                end
                ret = ret.chop
                ret += "]}"
              else
                ret = "{devices:[]}"
              end
            end
          end
          result = XXTEA.get_encrypt_str(ret.to_s, key)
        end
      end
    else
      result_code = 1
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
end