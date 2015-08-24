class PointsController < ApplicationController
  before_action :set_point, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @points = Point.all
    respond_with(@points)
  end

  def show
    respond_with(@point)
  end

  def new
    @point = Point.new
    respond_with(@point)
  end

  def edit
  end

  def create
    @point = Point.new(point_params)
    @point.save
    respond_with(@point)
  end

  def update
    @point.update(point_params)
    respond_with(@point)
  end

  def destroy
    @point.destroy
    respond_with(@point)
  end

  private
    def set_point
      @point = Point.find(params[:id])
    end

    def point_params
      params.require(:point).permit(:value, :seq_num)
    end
end
