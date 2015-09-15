module Apiv10
  class Util
    class << self
    public
      def get_params(data)
        url_params = {}

        begin
          data.split( /&/ ).inject( Hash.new { | h, k | h[k]='' } ) do | h, s |
            k, v = s.split( /=/ )
            h[k] << v
            url_params = h
          end        
        rescue Exception => e
          url_params
        end
      end

      def get_user_params(user_hash)
        
      end
  end
end