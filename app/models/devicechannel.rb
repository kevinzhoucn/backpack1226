class Devicechannel
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :device
  belongs_to :dchannel
  has_one :channel

  # has_many :points
  # has_many :dmodelchannels

  field :device_id, type: String
  field :dchannel_id, type: String
  field :name, type: String
  field :unit, type: String
  field :enable, type: Boolean, default: false # [0, 1]

  validates_presence_of :device_id, :dchannel_id, :name

  scope :recent, -> { desc(:created_at) }
  default_scope -> { where(enable: true) }

  public
    def self.UpdateChannels( device_id, channels )
      retResult = ''
      device = Device.find(device_id)
      if !device
        return '{ code: 1, message: "Device id:' + device_id + 'not found! " }'
      end

      # retResult = '{ code: 0, message: "'
      retResult02 = '{ code: 0, message: " Succeed! '
      retCount = 0
      channels.each do |channel|
        c_enable = channel[1][:enable]
        
        c_id = channel[1][:id]
        c_name = channel[1][:name]
        c_obj = Devicechannel.where(:device_id => device_id, :dchannel_id => c_id).first

        retResult02 += 'enable: ' + c_enable
        if ( c_obj )
          if ( c_enable == 'true')
            # retResult += ' c_id: ' + c_id + ', c_name: ' + c_name
            
            c_obj.update_attributes(:name => c_name, :enable => true)
            retCount += 1

            if ( !c_obj.channel )
              # c_channel = c_obj.channel.create(:channel_id => c_obj.dchannel.cid, :channel_name => c_name, :channel_type => 0, :channel_direct => 0, :device_id => device_id, :device_user_id => device.device_user_id)
              # retResult02 += 'create new channel: c_channel: ' + 'channel_name: ' + c_name + ', device_id:' + device_id + ', device_user_id: ' + device.device_id
              c_channel = Channel.create(:devicechannel_id => c_obj.id, :channel_id => c_obj.dchannel.cid, :channel_name => c_name, :channel_type => '0', :channel_direct => '0', :device_id => device_id, :device_user_id => device.device_id)
              # c_channel = c_obj.channel.create(:channel_id => c_obj.dchannel.cid, :channel_name => c_name, :channel_type => '0', :channel_direct => '0', :device_id => device_id, :device_user_id => device.device_id)
              retResult02 += 'create new channel: c_channel: ' + c_channel.id + 'channel_name: ' + c_name + ', device_id:' + device_id + ', device_user_id: ' + device.device_id
            end
            # retResult += ' update id: ' + c_obj.id + ' enable:true , '
          else
            c_obj.update_attributes(:enable => false)
            retCount += 1
          end
        end
        if ( !c_obj && c_enable == 'true' )
          c_obj = Devicechannel.create(:device_id => device_id, :dchannel_id => c_id, :name => c_name, :enable => true)
          # c_channel = c_obj.channel.create(:channel_id => c_obj.dchannel.cid, :channel_name => c_name, :channel_type => 0, :channel_direct => 0, :device_id => device_id, :device_user_id => device.device_user_id)
          # retResult02 += 'create new channel: c_channel: ' + c_channel.id + 'channel_name: ' + c_name + ', device_id:' + device_id + ', device_user_id: ' + device_user_id
          c_channel = Channel.create(:devicechannel_id => c_obj.id, :channel_id => c_obj.dchannel.cid, :channel_name => c_name, :channel_type => '0', :channel_direct => '0', :device_id => device_id, :device_user_id => device.device_id)
          retResult02 += 'create new channel: c_channel: ' + c_channel.id + 'channel_name: ' + c_name + ', device_id:' + device_id + ', device_user_id: ' + device.device_id
          retCount += 1
        end
      end
      retResult += '"}'
      retResult02 += 'updated: ' + retCount.to_s + ' records."}'

      return retResult02;
      # return '';
    end    
end