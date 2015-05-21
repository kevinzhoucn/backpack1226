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
            items = []
            @cmdqueries.each do |cmd|
              item = {}
              item[:channel] = cmd.channel_user_id
              item[:value] = cmd.value        
              items << item

              cmd.update_attributes( send_flag: 'Y')
            end

            ret = { :result => "0", :data => {:set => items } }
            render json: ret.to_json
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
end
