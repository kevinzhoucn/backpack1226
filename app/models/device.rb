class Device
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  belongs_to :dmodel
  has_many :channels
  has_many :cmdqueries
  has_many :devicechannels
  has_many :cmdquerystatuses
  has_one :deviceinfo

  field :device_id, type: String
  field :device_name, type: String
  field :device_description, type: String
  field :uid, type: String
  field :user_id, type: String
  field :dmodel_id, type: String
  field :onlinestatus, type: Boolean
  field :lastfailtime, type: String

  validates_presence_of :dmodel_id, :device_id, :device_name, :device_description

  scope :recent, -> { desc(:created_at) }

  public
    def update_online
      self.update_attributes( :onlinestatus => true )      
    end
    def update_offline
      self.update_attributes( :onlinestatus => false, :lastfailtime => Time.now.to_i.to_s )
    end
    def checkonline?
      return self.onlinestatus
    end
    def update_channels_cmdqueries( seq_num )
      self.channels.each do |channel|
        cmdquery = channel.cmdqueries.first
        if cmdquery 
          cmdquery.update_status( seq_num )
        end
      end
    end

    # Device startup, get last cmdquery status
    def get_last_cmdqueries
      items = ""
      self.channels.each do |channel|
        item = channel.get_last_cmdquery
        items << item.to_s + "_" if item.length > 2
      end      
      items.chop
    end

    def get_channels_cmdqueries
      items = ""
      self.channels.each do |channel|
        item = channel.get_cmdquery
        items << item.to_s + "_" if item
      end      
      items.chop
    end

    def get_channels_request_cmdqueries
      items = ""
      self.channels.each do |channel|
        item = channel.request_cmdquery
        item << item.to_s + "_" if item
      end
      items.chop
    end

    def get_device_json
      return "{id:'" + self.id + "',dev_id:'" + self.device_id + "',name:'" + self.device_name + "',description:'" + self.device_description + "',created_date:'" + self.created_at.to_s + "'},"
    end
end
