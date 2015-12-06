class Dmodel
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :dmodelchannel

  has_many :devices
  has_many :dchannels
  # has_many :dmodelchannel

  field :name, type: String
  field :description, type: String

  validates_presence_of :name, :description

  scope :recent, -> { desc(:created_at) }
end