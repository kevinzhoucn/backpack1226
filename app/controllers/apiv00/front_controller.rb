class Apiv00::FrontController < Apiv00::ApplicationController
  layout 'cpanel'

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


    str_test_01 = str = "user=user01@iot.com&datetime=20150522T220355P123&dev_id=dev01&random=1234567890ABCDEF"
    str_test_01 = "value=1-10-20150520T123030P123_2-120-20150520T123030P123&dev_id=dev01&random=1234567890ABCDEF"
    # str = "12345"    
    # raw_key = "D7iTLeFCRv8KSCUf"
    raw_key = "TmWwjnOHyPVAGAbE"
    # raw_key = "54321"

    @encrypt_str = get_encrypt_str(str_test_01, raw_key)

    @url_params = get_params(str_test_01)

    @values = @url_params['value']

    @values = @values.split('_')

    # raw_str = "f6506d872d1c0712aaf45b10dbd9d7bfada82155fcbe044594f3084f33f07462b1276b7b2ae36872b9573d1a91298a01a118841878e0919e6f9d8007777b74863498dc3f7df420d33595f8a39bfca7bc70eff937f09598"
    # raw_str = "8d672acd69cdd719"
    raw_str = @encrypt_str
    raw_str = "cf8c933f625ffa1e2165873fb188e39f17bef497a725f24bbb6f3e9d6bc1b1529912545aaa29ea81d2a720da1eead4a252aaabe3eb72ff58e0d52858b45a9a0940c7b2f7f07170c7006001a3e6ae577875d32bb8c02659b7fff5631332dee1f8"
    # raw_str = "39876da1b1e87283a7d881b5"
    # raw_key = "D7iTLeFCRv8KSCUf"
    @test_str = raw_str.length / 8
    @test_str2 = raw_str.length
    # @test_str3 = ""

    @decrypt_str = get_decrypt_str(raw_str, raw_key)


    @url_params = get_params(@decrypt_str)

    value = @url_params['value']

    @values = get_split_data ( value )
  end

  def test01
  end

  def test_data
    device = current_user.devices.first
    channel = device.channels.first
    cmdqueries = channel.cmdqueries

    data_points = cmdqueries.map {|item| item.value.to_i}

    render json: data_points
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

    def get_decrypt_str_02(raw_str, raw_key)
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

    def get_encrypt_str_02(raw_str, raw_key)
      encrypt_str = XXTEA.encrypt(raw_str, raw_key)
      return encrypt_str.unpack('N*').map { |m| m.to_s(16) }.join
      # send_str = ""
      # encrypt_str.each_byte do |chr|
      #   send_str << chr.to_s(16)
      # end
      # send_str
    end

    def get_encrypt_str(raw_str, raw_key)
      encrypt_str = XXTEA.encrypt(raw_str, raw_key)          
      return encrypt_str.unpack('N*').map { |m| format("%08x", m)}.join
    end

    def get_decrypt_str(raw_str, raw_key)
      decrypt_str = ""
      # if ( raw_str.length % 8 == 0 ) and raw_key.length == 16        
      #   i_length = raw_str.length / 8
      #   ret_str = []
      #   for i in 1..i_length
      #     start = ( i -1 ) * 8
      #     ret_str << raw_str.slice( start, 8 )
      #   end

      #   ret_str = ret_str.map { |m| m.to_i(16) }.pack('N*')
      #   decrypt_str = XXTEA.decrypt(ret_str, raw_key)
      # end

      # split_str = raw_str.split('H').map { |m| m.to_i(16) }.pack('N*')
      ret_str = raw_str.scan(/.{8}/).map { |m| m.to_i(16) }.pack('N*')
      decrypt_str = XXTEA.decrypt(ret_str, raw_key)
      decrypt_str
    end

    def get_split_data(values)
      data_array = values.split('_')
      data_test = []
        if data_array
          data_array.each do |tp_data|
            t_data_test = []
            data_content_array = tp_data.split('-')
            t_data_test << data_content_array[0]
            t_data_test << data_content_array[1]
            t_data_test << data_content_array[2]   

            data_test << t_data_test
          end
          # raw_str = "0," + values +","+random_str
        else
          # raw_str = "3"
        end
      data_test
    end
end