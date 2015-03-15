class Channel
  include Mongoid::Document
  field :title, type: String
  field :channel_type, type: String
  field :channel_name, type: String
  field :device_id, type: String
  field :user_id, type: String

  validates_presence_of :channel_name, :channel_type, :device_id

  belongs_to :device
end
