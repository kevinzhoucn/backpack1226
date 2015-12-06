class Cpanel::CmdqueriesController < Cpanel::ApplicationController
  before_action :set_cmdquery, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @cpanel_cmdqueries = Cmdquery.all
    respond_with(@cpanel_cmdqueries)
  end

  def show
    respond_with(@cpanel_cmdquery)
  end

  def new
    @cpanel_cmdquery = Cmdquery.new

    @device = Device.find(params[:id])
    @channel = Channel.find(params[:cid])
    respond_with(@cpanel_cmdquery)
  end

  def set
    device_id = params[:id]
    @device = Device.find(device_id)
    @channel = Channel.find(params[:cid])

    # @cmdqueries = Cmdquery.where( :device_id => @device.id )
    # @cmdqueries = Cmdquery.where( :device_id => device_id )
    # @cmdqueries = Cmdquery.where( device_id: params[:id], channel_id: params[:cid] )
    # @cmdqueries = Cmdquery.where( channel_id: params[:cid] )
    # @cmdqueries = Cmdquery.all
  end

  def set_create
    # @cpanel_cmdquery = Cmdquery.new(cmdquery_params)
    cmdquery = Cmdquery.new

    device_id = cmdquery_params[:device_id].gsub(/\s+/, "")
    channel_id = cmdquery_params[:channel_id].gsub(/\s+/, "")
    channel_user_id = cmdquery_params[:channel_user_id].gsub(/\s+/, "")
    # value = cmdquery_params[:value].gsub(/\s+/, "")
    value = cmdquery_params[:value]

    cmdquery.device_id = device_id
    cmdquery.channel_id = channel_id
    cmdquery.channel_user_id = channel_user_id
    cmdquery.value = value
    cmdquery.send_flag = 'N'
    cmdquery.save

    render text: cmdquery.id
  end

  def edit
  end

  def create
    @cpanel_cmdquery = Cmdquery.new(cmdquery_params)
    @cpanel_cmdquery.send_flag = 'N'
    @cpanel_cmdquery.save
    #respond_with(@cpanel_cmdquery)

    redirect_to front_show_device_path(@cpanel_cmdquery.device_id)
  end

  def update
    @cpanel_cmdquery.update(cmdquery_params)
    respond_with(@cpanel_cmdquery)
  end

  def destroy
    @cpanel_cmdquery.destroy
    respond_with(@cpanel_cmdquery)
  end

  private
    def set_cmdquery
      @cpanel_cmdquery = Cmdquery.find(params[:id])
    end

    def cmdquery_params
      params.require(:cmdquery).permit(:device_id, :device_user_id, :channel_id, :channel_user_id, :value)
    end
end
