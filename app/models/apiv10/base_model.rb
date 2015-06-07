module Apiv10
  module BaseModel
    public
      def get_params_01(data)
        url_params = {}

        data.split( /&/ ).inject( Hash.new { | h, k | h[k]='' } ) do | h, s |
          k, v = s.split( /=/ )
          h[k] << v
          h
        end
      end
  end
end