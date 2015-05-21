class Apiv00::FrontController < Apiv00::ApplicationController

  def index
    @text = "this is test text!"

    channel = Channel.last
    @cmd = Cmdquery.where(:channel_id => channel, :send_flag => 'N' ).last 
  end
end