class Apiv10::ApibaseController < Apiv10::ApplicationController
  # include Apiv10::BaseModel
  before_action :set_params, only: [:datetime, :cmdquery, :getoutvalue, :devinfo]
  layout 'appprofile', only: [:xxtea]

  def cmdquery
    cmd_query_items = ""
    random_server_code = 1000

    begin
      setcmdstatus

      if @device
        60.times {
          local_ret_str = ""
          cmd_query_items = @device.get_channels_cmdqueries
          if cmd_query_items.length > 2
            local_ret_str << cmd_query_items.to_s
            # break
          end

          cmd_request_query_items = @device.get_channels_request_cmdqueries
          if cmd_request_query_items.length > 2
            local_ret_str << "_" + cmd_request_query_items.to_s
          end

          if local_ret_str.length > 2
            @ret_str << local_ret_str
            break
          end
          sleep(5)
        }

        cmdstatus = @device.cmdquerystatuses.first
        if cmdstatus and cmdstatus.seq_num
          random_server_code = cmdstatus.seq_num + 1
          # cmdstatus = @device.cmdquerystatuses.create(:seq_num => random_server_code, :status => false)
        end
        cmdstatus = @device.cmdquerystatuses.create(:seq_num => random_server_code, :status => false)
      end      
    rescue Exception => e
      @ret_str = "4,"      
    end

    @ret_str << "," + @random_str.to_s + "," + random_server_code.to_s if @user

    ret_encrypt_str = XXTEA.get_encrypt_str(@ret_str, @raw_key)
    render text: "result:" + ret_encrypt_str
  end

  def getoutvalue
    if @device
      @ret_str << @device.get_last_cmdqueries
    end     

    @ret_str << "," + @random_str.to_s + "," + "1234"

    ret_encrypt_str = XXTEA.get_encrypt_str(@ret_str, @raw_key)
    render text: "result:" + ret_encrypt_str
  end

  def devinfo
    ret_encrypt_str = ''
    if @user and @device
      if !@device.deviceinfo
        obj = Deviceinfo.build_object( @device.id, @data_params )
        if obj.save
          ret_encrypt_str = get_return_string(0)
        else
          ret_encrypt_str = get_return_string(1)
        end
      else
        ret_encrypt_str = get_return_string(0)
      end
    else
      ret_encrypt_str = get_return_string(3)
    end
    render text: "result:" + ret_encrypt_str
  end

  def getdevinfo
    devinfo_list = Deviceinfo.all

    render json: devinfo_list.to_json
  end

  def cmdsuccess
    device_id = params[:id]
    device = Device.find(device_id)
    statuscode = false
    retJson = '{ "code" : "' + statuscode.to_s + '"'

    channel_id = params[:cid]
    channel = device.channels.find(channel_id)
    if channel and channel.cmdqueries.first
      cmdquery = channel.cmdqueries.first
      statuscode = cmdquery.status
      retJson = '{ "code" : "' + statuscode.to_s + '"'
      retJson << ', "cmd" : { "value": "' + cmdquery.value + '", "create_at" : "' + cmdquery.created_at.strftime('%F %T').to_s + '" }'
    end

    retJson << ' }'

    render json: retJson.to_json
  end

  def onlinestatus
    device_id = params[:id]
    device = Device.find(device_id)    

    cmdstatus = device.cmdquerystatuses.first
    cmdstatuscode = false
    if cmdstatus
      cmdstatuscode = cmdstatus.status ? cmdstatus.status : false
    end

    retJson = '{ "code" : "' + cmdstatuscode.to_s + '", "updated_at" : "' + Time.now.strftime('%T')  + '"}'
    render json: retJson.to_json
  end

  def datetime
    # date_time = DateTime.parse(Time.now.to_s).strftime('%Y%m%dT%H%M%S').to_s    
    date_time = Time.now.to_i * 1000
    @ret_str = "0," + date_time.to_s  if @device
    @ret_str << "," + @random_str.to_s if @user

    ret = XXTEA.get_encrypt_str(@ret_str, @raw_key)
    render text: "result:" + ret
  end

  def receive_data
    data = params[:data]
    user_id = params[:user]
    date_time = DateTime.parse(Time.now.to_s).strftime('%Y%m%dT%H%M%S').to_s

    raw_str = "3,"
    raw_key = ""

    begin
      if not data or data.length < 5
        raw_str = "3,"
      else 
        if ( not user_id or user_id.length < 5 ) or ( not User.where(:email => user_id).exists? )
          raw_str = "1,"
        else
          user = User.where(:email => user_id).first

          raw_key = user.devices_key

          data_raw = XXTEA.get_decrypt_str(data, raw_key)

          if data_raw and data_raw.length < 5
            raw_str = "3,"
          else
            url_params = get_params(data_raw)

            dev_id = url_params['dev_id']
            values = url_params['value']
            random_str = url_params['random']

            device = Device.where( :device_id => dev_id, :user_id => user.id ).first

            if device
              data_array = values.split('_')
              data_test = []
              if data_array
                data_array.each do |tp_data|
                  data_content_array = tp_data.split('-')
                  data_test << data_content_array[0]
                  data_test << data_content_array[1]
                  data_test << data_content_array[2]
                  if data_content_array
                    @channel = Channel.where(:channel_id => data_content_array[0], :device_id => device).first
                    if @channel
                      data_point = data_content_array[1] + '-' + data_content_array[2]
                      @channel.add_point(data_point)
                      # data_points = @channel.data_points ? @channel.data_points : ""
                      # data_points = data_points + "||" + data_content_array[1] + '-' + data_content_array[2]

                      # @channel.update_attribute(:data_points, data_points)

                      # data_test << data_points
                    end
                  end
                end
                raw_str = "0,,"+ random_str
              else
                raw_str = "3,"
              end
            else
              raw_str = "2,"
            end
          end
        end
      end
    rescue
      raw_str = "3,"
    end
    ret = XXTEA.get_encrypt_str(raw_str, raw_key)
    render text: "result:" + ret
  end

  def xxtea

  end

  def xxtea_encrypt
    raw_str = params[:str]
    raw_key = params[:key]

    ret = XXTEA.get_encrypt_str(raw_str, raw_key)

    render text: ret
  end
  def xxtea_decrypt
    raw_str = params[:str]
    raw_key = params[:key]

    ret = XXTEA.get_decrypt_str(raw_str, raw_key)

    render text: ret
  end
  def md5_encrypt
    raw_str = params[:str]
    raw_key = params[:key]

    ret = Devise::Encryptable::Encryptors::Md5.digest(raw_str, nil, raw_key, nil)

    render text: ret
  end

  private
    def set_device
      @device = Device.find(params[:id])
    end
    
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

    def set_params
      user_email = params[:user]
      user_data = params[:data]
      @ret_str = "0,"
      @raw_key = ""
      @random_str = ""

      if User.where(email: user_email).exists?
        @user = User.find_by(email: user_email)
        @raw_key = @user.devices_key

        if user_data and user_data.length > 8
          raw_data = XXTEA.get_decrypt_str(user_data, @user.devices_key)
          @data_params = get_params(raw_data)
        end

        if @data_params and @data_params.has_key?('dev_id')
          dev_id = @data_params['dev_id']
          @random_str = @data_params['random']
          if Device.where(device_id: dev_id, user_id: @user.id).exists?
            @device = Device.find_by(device_id: dev_id, user_id: @user.id)
          else
            @ret_str = "2,"
          end
        else
          @ret_str = "3,"
        end        
      else
        @ret_str = "1,"
      end
    end

    def setcmdstatus
      if @data_params and @data_params.has_key?('seq')
        @seq = @data_params['seq']
        if @seq
          @cmdstatus = @device.cmdquerystatuses.where( :seq_num => @seq ).first
          @device.update_channels_cmdqueries( @seq )
        end

        if @cmdstatus
          @cmdstatus.update_attributes( :status => true )
          # @device.update_channels_cmdqueries( @seq )
        else
          @device.cmdquerystatuses.create(:seq_num => 1000, :status => true) 
        end
      end
    end

    def get_return_string( code )
      ret_str = code.to_s + "," + @random_str.to_s
      return XXTEA.get_encrypt_str(ret_str, @raw_key)
    end
end
