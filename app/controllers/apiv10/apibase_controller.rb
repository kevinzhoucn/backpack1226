class Apiv10::ApibaseController < Apiv10::ApplicationController

  def cmdquery
    device_id = params[:dev_id]
    @cmdqueries = Cmdquery.where(:device_id => device_id)

    if @cmdqueries.empty?
      ret = { :result => {:code => "1", :message => "success!"}, :data => { :content => @cmdqueries } }
      render json: ret.to_json
    else
      ret = { :result => {:code => "0", :message => "fail!"}, :data => { } }
      render json: ret.to_json
    end
  end

end