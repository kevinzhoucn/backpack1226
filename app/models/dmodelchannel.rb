class Dmodelchannel
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :device
  belongs_to :dchannel
  has_many :points

  field :device_id, type: String
  field :dchannel_id, type: String

  validates_presence_of :device_id, :dchannel_id

  scope :recent, -> { desc(:created_at) }
end