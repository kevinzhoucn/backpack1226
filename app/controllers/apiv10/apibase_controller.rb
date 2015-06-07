class Apiv10::ApibaseController < Apiv10::ApplicationController
  def cmdquery
    user_name = params[:user]
    data = params[:data]

    t_user = User.where(:email => user_name).first

    ret_str = "1,"
    raw_str_key = "1234567890abcdef"
    random_str = ","

    if t_user
      raw_str_key = t_user.devices_key
    else
      ret_str = "1,"
    end

    begin

      if raw_str_key and raw_str_key.length == 16
        data_raw = XXTEA.get_decrypt_str(data, raw_str_key)

        if data_raw and data_raw.length > 5
          url_params = get_params(data_raw)
          dev_id = url_params['dev_id']
          random_str = url_params['random']

          device = Device.where(:device_id => dev_id, :user_id => t_user).first
          if device
            5.times {
              cmd = Cmdquery.where(:device_id => device).last
              if cmd
                send_flag = cmd.send_flag
                if send_flag == "N"
                  cmdqueries = []
                  channels = Channel.where(:device_id => device)

                  channels.each do |channel|
                    t_cmd = Cmdquery.where(:channel_id => channel, :send_flag => 'N' ).last
                    if t_cmd
                      cmdqueries << t_cmd
                    end
                  end

                  if cmdqueries.length > 0
                    items = ""
                    cmdqueries.each do |cmd|
                      item = ""
                      item += cmd.channel_user_id + '-'
                      item += cmd.value + '_'
                      items += item

                      cmd.update_attributes( send_flag: 'Y')
                    end
                    ret_str = "0," + items.chop
                  end
                  break
                end
              else
                ret_str = "0,"                
              end

              sleep(2)
            }
          else
            ret_str = "2,"
          end
        else
          ret_str = "3,"
        end
      end
    rescue
      ret_str = "4,"
    end

    random_server_code = "1234"
    ret_str = ret_str + "," + random_str + "," + random_server_code

    ret_encrypt_str = XXTEA.get_encrypt_str(ret_str, raw_str_key)
    render text: "result:" + ret_encrypt_str
  end

  def cmdquery_01
    device_id = params[:dev_id]
    device = Device.where(:device_id => device_id).first

    # send_flag = Cmdquery.last
    i = 10

    5.times {
      # cmd = Cmdquery.last
      cmd = Cmdquery.where(:device_user_id => device_id).last
      if cmd
        send_flag = cmd.send_flag

        if send_flag == "N"
          @cmdqueries = []
          @channels = Channel.where(:device_id => device)

          @channels.each do |channel|
            t_cmd = Cmdquery.where(:channel_id => channel, :send_flag => 'N' ).last
            if t_cmd
              @cmdqueries << t_cmd
            end
            # @cmdqueries << Cmdquery.where(:channel_id => channel, :send_flag => 'N' ).last
            # @cmdqueries << Cmdquery.last
          end

          if @cmdqueries.length > 0
            #### old method
            # items = []
            # @cmdqueries.each do |cmd|
            #   item = {}
            #   item[:channel] = cmd.channel_user_id
            #   item[:value] = cmd.value        
            #   items << item

            #   cmd.update_attributes( send_flag: 'Y')
            # end

            #### new method
            items = ""
            @cmdqueries.each do |cmd|
              item = ""
              item += cmd.channel_user_id + '-'              
              item += cmd.value + '_'
              items += item

              cmd.update_attributes( send_flag: 'Y')
            end

            ret = { :result => "0", :data => {:set => items.chop } }
            render json: ret.to_json
            return
          end
        end
      end

      sleep(5)
    }

    # ret = { :result => {:code => "1", :message => "fail, time out!"} }
    ret = { :result => "1" }
    render json: ret.to_json

    # while send_flag != 'N' and i++ < 5
    #   send_flag = Cmdquery.last      
    #   sleep(1)
    # end

    # sleep(15)

    # @cmdqueries = []
    # @channels = Channel.where(:device_id => device)

    # @channels.each do |channel|
    #   @cmdqueries << Cmdquery.where(:channel_id => channel).last
    # end

    # if @cmdqueries
    #   items = []
    #   @cmdqueries.each do |cmd|
    #     item = {}
    #     item[:channel] = cmd.channel_user_id
    #     item[:value] = cmd.value        
    #     items << item
    #   end

    #   ret = { :result => {:code => "0", :message => "success!"}, :data => { :set => items } }
    #   render json: ret.to_json
    # else
    #   ret = { :result => {:code => "0", :message => "fail!"}, :data => { } }
    #   render json: ret.to_json
    # end
  end

  def datetime
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
            random_str = url_params['random']

            device = Device.where(dev_id: "iot02").first

            if Device.where(:device_id => dev_id).exists?
              raw_str = "0," + date_time + "," + random_str
            else
              raw_str = "2,," + random_str
            end
          end

          # raw_str = "2 -- dev_id:" + url_params

          # if true
          #   raw_str = "0, data:" + date_time
          # end
        end
      end
    rescue
      raw_str = "3,"
    end

    # if user_id != current_user
    # ret = { :result => "0", :datetime => date_time }
              
    ret = XXTEA.get_encrypt_str(raw_str, raw_key)
    # ret = raw_str
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

            device = Device.where( :device_id => dev_id, :user_id => user ).first

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
                      data_points = @channel.data_points ? @channel.data_points : ""
                      data_points = data_points + "||" + data_content_array[1] + '-' + data_content_array[2]

                      @channel.update_attribute(:data_points, data_points)

                      data_test << data_points
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

  private
    def set_device
      @device = Device.find(params[:id])
    end

    def get_params(data)
      url_params = {}

      data.split( /&/ ).inject( Hash.new { | h, k | h[k]='' } ) do | h, s |
        k, v = s.split( /=/ )
        h[k] << v
        h
      end

      # data.split('&').each do |data1|
      #   data1.split('=').each do |data2|
      #     url_params
      #   end
      # end
    end

    def get_encrypt_str_01(raw_str, raw_key)
      encrypt_str = XXTEA.encrypt(raw_str, raw_key)          
      return encrypt_str.unpack('N*').map { |m| format("%08x", m)}.join
    end

    def get_decrypt_str_02(raw_str, raw_key)
      decrypt_str = ""
      # if ( raw_str.length % 8 == 0 ) and raw_key.length == 16        
      #   i_length = raw_str.length / 8
      #   ret_str = []
      #   for i in 1..i_length
      #     start = ( i -1 ) * 8
      #     ret_str << raw_str.slice( start, 8 )
      #   end

      #   ret_str = ret_str.map { |m| m.to_i(16) }.pack('N*')
      #   decrypt_str = XXTEA.decrypt(ret_str, raw_key)
      # end

      # split_str = raw_str.split('H').map { |m| m.to_i(16) }.pack('N*')
      ret_str = raw_str.scan(/.{8}/).map { |m| m.to_i(16) }.pack('N*')
      decrypt_str = XXTEA.decrypt(ret_str, raw_key)
      decrypt_str
    end
end
