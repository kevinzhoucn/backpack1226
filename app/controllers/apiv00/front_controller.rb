class Apiv00::FrontController < Apiv00::ApplicationController

  def index
    @text = "this is test text!"

    channel = Channel.last
    @cmd = Cmdquery.where(:channel_id => channel, :send_flag => 'N' ).last 


    str01 = "123456789"
    str_key = "1234567890abcdef"

    # @str_to_long = XXTEA.encrypt(str01, str_key)
    # @str_to_long = XXTEA.encode_test(str01, str_key)

    # @str_to_long = XXTEA.encrypt(str01, str_key).to_s

    # render json: @str_to_long.to_json


    str = "user=user01@iot.com&datetime=20150522T220355P123&dev_id=iot02&random=1234567890ABCDEF"

    @url_params = get_params(str)


    raw_str = "2f3e07c05c1f5f1b9bbe9a3ae41352f11d2e10b5632c054f126d4a2ac32c3c6a49a4ddb9ee4eeaf2ac130d682999dcc29da0ac14afb1fd9961fd6eaf62166696cee4c42ea63e943c4d97501e40558cf1d2fbc6555278fd67"
    # raw_str = "39876da1b1e87283a7d881b5"
    raw_key = "D7iTLeFCRv8KSCUf"
    @test_str = raw_str.length % 8
    @test_str2 = raw_str.length
    @decrypt_str = get_decrypt_str(raw_str, raw_key)
  end

  private
    def get_params(data)
      url_params = {}

      data.split( /&/ ).inject( Hash.new { | h, k | h[k]='' } ) do | h, s |
        k, v = s.split( /=/ )
        h[k] << v
        h
      end
    end

    def get_decrypt_str(raw_str, raw_key)
      decrypt_str = ""
      if true #( raw_str.length % 8 == 0 ) and raw_key.length == 16
        str = raw_str.scan(/.{8}/).map { |m| m.to_i(16) }.pack('N*')
        decrypt_str = XXTEA.decrypt(str, raw_key)
      end
      decrypt_str
    end
end