class Device
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  has_many :channels
  has_many :cmdqueries

  field :device_id, type: String
  field :device_name, type: String
  field :device_description, type: String
  field :uid, type: String
  field :user_id, type: String

  validates_presence_of :device_id, :device_name, :device_description

  scope :recent, -> { desc(:created_at) }

  public
    def get_channels_cmdqueries
      items = ""
      self.channels.each do |channel|
        item = channel.get_cmdquery
        items << item.to_s + "_" if item
      end      
      items.chop
    end
end
