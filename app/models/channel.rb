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
  has_many :points

  # scope :channel_id_asc { | id |  }

  # before_update :setup_device_user_id
  public 
    def get_cmdquery
      cmd = self.cmdqueries.wait_for_send.last
      if cmd
        self.cmdqueries.wait_for_send.each do | t_cmd |
          t_cmd.update_attributes( send_flag: 'Y')
        end

        cmd.get_command.to_s
      end
    end

    def request_cmdquery
      cmd = self.cmdqueries.wait_for_request.last
      if cmd
        self.cmdqueries.wait_for_request.each do | t_cmd |
          t_cmd.update_attributes( send_request_flag: 'N')
        end

        cmd.request_command.to_s
      end
    end

    def get_seq_cmdqueries_datapoints(seq_num)
      datapoints = []
      datapoints << self.cmdqueries.last.seq_num
      if not seq_num or seq_num == "0000"
        datapoints << self.cmdqueries.desc(:created_at).limit(20).map { | item | item.value.to_i }
      else
        datapoints << self.cmdqueries.where(:seq_num.gt => seq_num).limit(20).map { | item | item.value.to_i }
      end
      return datapoints
    end

    def get_seq_points(seq_num)
      datapoints = []
      # datapoints << self.points.last.seq_num
      if not seq_num or seq_num == "0000"
        datapoints = self.points.desc(:created_at).map { | item | [item.date_int.to_i, item.value.sub(/[N]/, '-').to_i]  }
        # datapoints << self.data_points.to_s
      else
        datapoints = self.points.where(:seq_num.gt => seq_num.to_i).map { | item | [item.date_int.to_i, item.value.sub(/[N]/, '-').to_i] }
      end
      return datapoints
    end

    def add_point(data_value)
      if data_value.split('-').length > 1
        data = data_value.split('-')[0]
        data_time = data_value.split('-')[1]
        data_int = TEAUTIL.get_date_seconds(data_time)
        point = self.points.build(:value => data, :date_str => data_time, :date_int => data_int)
        if get_last_seq_number != "0000"
          seq_num = self.points.last.seq_num + 1
          point.seq_num = seq_num
        else
          point.seq_num = 0
        end

        point.save
      end
    end

    def get_last_seq_number
      seq_num = "0000"
      point_last = self.points.last
      if point_last and point_last.seq_num
        seq_num = point_last.seq_num
      end
      return seq_num
    end

  private
    def setup_device_user_id
      device_user_id = Device.find(self.device_id)
      self.device_user_id = device_user_id.device_id
    end
end
