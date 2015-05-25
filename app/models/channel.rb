class Channel
  include Mongoid::Document
  include Mongoid::Timestamps
  field :title, type: String
  field :channel_id, type: Integer#String
  field :channel_type, type: String # [['1. 模拟  ', '0'], ['2. 数字  ', '1'], ['3. 串口  ', '2']]
  field :channel_name, type: String
  field :channel_direct, type: String # [['1. 输入  ', '0'], ['2. 输出  ', '1']]
  field :device_id, type: String
  field :device_user_id, type: String
  field :user_id, type: String

  field :data_points, type: String

  validates_presence_of :channel_id, :channel_name, :channel_type, :device_id, :device_user_id

  belongs_to :device
  has_many :cmdqueries

  # scope :channel_id_asc { | id |  }

  # before_update :setup_device_user_id

  private
    def setup_device_user_id
      device_user_id = Device.find(self.device_id)
      self.device_user_id = device_user_id.device_id
    end
end
