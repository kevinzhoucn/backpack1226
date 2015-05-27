class Apiv10::ApibaseController < Apiv10::ApplicationController

  def cmdquery
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
    date_time = DateTime.parse(Time.now.to_s).strftime('%Y-%m-%dT%H:%M:%S').to_s

    if not data or data.length < 5
      ret = { :result => "3" }
    else 
      if ( not user_id or user_id.length < 5 ) and User.where(:email => user_id).exists?
        ret = { :result => "1" }
      else
        user = User.where(:email => user_id).first
        key = user.devices_key

        # data_raw = XXTEA.decrypt(data, key)

        # url_params = get_params(data_raw)

        # dev_id = url_params[:dev_id]

        # if Device.where(:dev_id => dev_id).exists?
        #   ret = { :result => "0", :datatime => date_time }
        # else
        #   ret = { :result => "2" }
        # end

        if true
          encrypt_str = XXTEA.encrypt(date_time, key)
          send_str = ""
          encrypt_str.each_byte do |chr|
            send_str << chr.to_s(16)
          end
          ret = { :result => "0", :datatime => send_str }
        end
      end
    end

    # if user_id != current_user
    # ret = { :result => "0", :datetime => date_time }
    render json: ret.to_json
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
end
