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

  def edit
  end

  def create
    @cpanel_cmdquery = Cmdquery.new(cmdquery_params)
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
      params.require(:cmdquery).permit(:device_id, :channel_id, :value)
    end
end
