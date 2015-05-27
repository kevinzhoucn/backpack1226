class Apiv00::FrontController < Apiv00::ApplicationController

  def index
    @text = "this is test text!"

    channel = Channel.last
    @cmd = Cmdquery.where(:channel_id => channel, :send_flag => 'N' ).last 


    str01 = "123456789"
    str_key = "1234567890abcdef"

    # @str_to_long = XXTEA.encrypt(str01, str_key)
    @str_to_long = XXTEA.encode_test(str01, str_key)

    # @str_to_long = XXTEA.encrypt(str01, str_key).to_s

    render json: @str_to_long.to_json
  end
end