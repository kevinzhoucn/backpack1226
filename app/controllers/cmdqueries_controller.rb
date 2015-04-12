class CmdqueriesController < ApplicationController
  before_action :set_cmdquery, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @cmdqueries = Cmdquery.all
    respond_with(@cmdqueries)
  end

  def show
    respond_with(@cmdquery)
  end

  def new
    @cmdquery = Cmdquery.new
    respond_with(@cmdquery)
  end

  def edit
  end

  def create
    @cmdquery = Cmdquery.new(cmdquery_params)
    @cmdquery.save
    respond_with(@cmdquery)
  end

  def update
    @cmdquery.update(cmdquery_params)
    respond_with(@cmdquery)
  end

  def destroy
    @cmdquery.destroy
    respond_with(@cmdquery)
  end

  private
    def set_cmdquery
      @cmdquery = Cmdquery.find(params[:id])
    end

    def cmdquery_params
      params.require(:cmdquery).permit(:device_id, :channel_id, :value)
    end
end
