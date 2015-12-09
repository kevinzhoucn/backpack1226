class Deviceinfo
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :device

  field :device_id, type: String
  field :iotmodule, type: String
  field :version, type: String
  field :sn, type: String

  # validates_presence_of :iotmodule, :device_id, :version, :sn
  public
    def self.build_object( device_id, data_params )
      iotmodule = 'empty'
      version = 'empty'
      sn = 'empty'
      
      if data_params and data_params.has_key?('IOTmodule')
        iotmodule = data_params['IOTmodule']
      end

      if data_params and data_params.has_key?('Version')
        version = data_params['Version']
      end

      if data_params and data_params.has_key?('SN')
        sn = data_params['SN']
      end

      obj = Deviceinfo.new( :device_id => device_id, :iotmodule => iotmodule, :version => version, :sn => sn ) 
      return obj
    end
end
