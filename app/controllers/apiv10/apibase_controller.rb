class Apiv10::ApibaseController < Apiv10::ApplicationController

  def cmdquery
    device_id = params[:dev_id]
    device = Device.where(:device_id => device_id).first

    send_flag = Cmdquery.last
    i = 0

    # while send_flag != 'N' and i++ < 5
    #   send_flag = Cmdquery.last      
    #   sleep(1)
    # end

    # sleep(15)

    @cmdqueries = []
    @channels = Channel.where(:device_id => device)

    @channels.each do |channel|
      @cmdqueries << Cmdquery.where(:channel_id => channel).last
    end

    if @cmdqueries
      items = []
      @cmdqueries.each do |cmd|
        item = {}
        item[:channel] = cmd.channel_user_id
        item[:value] = cmd.value        
        items << item
      end

      ret = { :result => {:code => "1", :message => "success!"}, :data => { :set => items } }
      render json: ret.to_json
    else
      ret = { :result => {:code => "0", :message => "fail!"}, :data => { } }
      render json: ret.to_json
    end
  end
end