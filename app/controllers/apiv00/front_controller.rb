class Apiv00::FrontController < Apiv00::ApplicationController

  def index
    @text = "this is test text!"

    channel = Channel.last
    @cmd = Cmdquery.where(:channel_id => channel, :send_flag => 'N' ).last 


    str01 = "12345"
    str_key = "54321"

    @result = []

    # @str_to_long = XXTEA.encrypt(str01, str_key)
    # @str_to_long = XXTEA.encode_test(str01, str_key)

    # @str_to_long = XXTEA.encrypt(str01, str_key).to_s

    # render json: @str_to_long.to_json
    # @result << XXTEA.encrypt(str01, str_key).unpack('N*').map { |m| m.to_s(16) }.join()


    str_test_01 = str = "user=user01@iot.com&datetime=20150522T220355P123&dev_id=iot02&random=1234567890ABCDEF"
    # str = "12345"    
    raw_key = "D7iTLeFCRv8KSCUf"
    raw_key = "54321"

    @encrypt_str = get_encrypt_str(str_test_01, raw_key)

    @url_params = get_params(str_test_01)


    # raw_str = "f6506d872d1c0712aaf45b10dbd9d7bfada82155fcbe044594f3084f33f07462b1276b7b2ae36872b9573d1a91298a01a118841878e0919e6f9d8007777b74863498dc3f7df420d33595f8a39bfca7bc70eff937f09598"
    raw_str = "8d672acd69cdd719"
    raw_str = @encrypt_str
    # raw_str = "39876da1b1e87283a7d881b5"
    # raw_key = "D7iTLeFCRv8KSCUf"
    @test_str = raw_str.length / 8
    @test_str2 = raw_str.length
    # @test_str3 = ""
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
        ret_str = str = raw_str.scan(/.{8}/).map { |m| m.to_i(16) }.pack('N*')

        i_length = raw_str.length / 8
        ret_str = []
        for i in 1..i_length
          start = ( i -1 ) * 8
          ret_str << raw_str.slice( start, 8 )
        end

        ret_str = ret_str.map { |m| m.to_i(16) }.pack('N*')

        decrypt_str = XXTEA.decrypt(ret_str, raw_key)
      end
      decrypt_str
    end

    def get_encrypt_str(raw_str, raw_key)
      encrypt_str = XXTEA.encrypt(raw_str, raw_key)
      return encrypt_str.unpack('N*').map { |m| m.to_s(16) }.join
      # send_str = ""
      # encrypt_str.each_byte do |chr|
      #   send_str << chr.to_s(16)
      # end
      # send_str
    end
end