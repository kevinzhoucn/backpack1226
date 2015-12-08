class Dmodel::FrontController < Dmodel::ApplicationController
  layout 'appprofile'
  before_filter :authenticate_user!

  before_action :set_device, only: [:index, :dchannel, :enabledchannel]

  def index
    @dmodel = Dmodel.first
    @channels = Dchannel.where(:dmodel_id => @dmodel.id)
  end

  def dchannel
    @channels = @device.dmodel.dchannels
    @di_channels = @device.dmodel.dchannels.d_input
    @do_channels = @device.dmodel.dchannels.d_output
    @ai_channels = @device.dmodel.dchannels.a_input
    @ao_channels = @device.dmodel.dchannels.a_output
  end

  def enabledchannel
    @channels = @device.devicechannels.where(:enable => true)
  end

  def editchannel
    # {data: [{device_id, dchannel_id, name, unit}, {device_id, dchannel_id, name, unit}]}
    @device_id = params[:device]
    @channels = params[:channels]
    retResult = Devicechannel::UpdateChannels( @device_id, @channels )

    render :text => retResult
  end

  def channel_delete_points
    channel_id = params[:id]
    channel = Channel.find(channel_id)
    if channel
      channel.points.delete_all
      # render :json => { code: 0, message: 'succeed!'}
    else
      # render :json => { code: 1, message: 'channel not exiting!'}
    end

    redirect_to dmodel_device_dchannel_set_path(channel.device.id)
  end

  def getChannel
    device_id = '5652cb09553031656c010000'
    channels = { "0" => {"id"=>"5656b8d75530315c08010000", "name"=>"Input000", "enable"=>"true"}, "1" => {"id"=>"5656b8d75530315c08020000", "name"=>"Input1", "enable"=>"true"},  \
                 "2" => {"id"=>"5656b8d75530315c08060000", "name"=>"Input1", "enable"=>"true"}, \
                 "3" => {"id"=>"5656b8d75530315c08070000", "name"=>"Input1", "enable"=>"true"} }

    # retResult = channels['0']['id']

    retResult = Devicechannel::UpdateChannels( device_id, channels )
    # retResult = Devicechannel.first
    # retResult = Devicechannel.all
    # retResult = Devicechannel.last

    render :text => retResult
    # render :text => retResult.name
    # render :text => "#{ retResult.id } . #{ retResult.device_id } . #{ retResult.enable }"
  end

  private
    def set_device
      @device = Device.find(params[:id])
    end
end
