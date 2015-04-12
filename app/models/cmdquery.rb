class Cmdquery
  include Mongoid::Document
  field :device_id, type: String
  field :channel_id, type: String
  field :value, type: String

  belongs_to :device
  belongs_to :channel
end
