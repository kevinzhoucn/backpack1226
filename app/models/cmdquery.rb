class Cmdquery
  include Mongoid::Document
  field :device_id, type: String
  field :device_user_id, type: String
  field :channel_id, type: String
  field :channel_user_id, type: String
  field :value, type: String
  field :send_flag, type: String

  belongs_to :device
  belongs_to :channel

  def get_channel_cmd
    
  end
end
