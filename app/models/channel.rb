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
  field :exp_str, type: String

  field :data_points, type: String
  field :devicechannel_id, type: String

  validates_presence_of :channel_id, :channel_name, :channel_type, :channel_direct, :device_id, :device_user_id

  belongs_to :device
  belongs_to :devicechannel

  has_many :cmdqueries
  has_many :points

  # scope :channel_id_asc { | id |  }

  # before_update :setup_device_user_id
  public 
    def isdoutput?
      self.devicechannel.dchannel.isdoutput?
    end

    def isaoutput?
      self.devicechannel.dchannel.isaoutput?
    end

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

    def get_last_cmdquery
      retValue = ''
      cmd = self.cmdqueries.first

      if cmd
        retValue = cmd.get_command
      end
      return retValue
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

    def get_data_points
      datapoints = []
      datapoints = self.points.asc(:date_int).map { | item | [item.date_int.to_i, item.value.sub(/[N]/, '-').to_i]  }
    end

    def get_seq_points(seq_num)
      # points_num = WEBPAGE_POINTS_NUM ? WEBPAGE_POINTS_NUM : 500
      points_num = 100
      datapoints = []
      # datapoints << self.points.last.seq_num
      # if not seq_num or seq_num == "0000"
      #   datapoints = self.points.desc(:date_int).limit(points_num).map { | item | [item.date_int.to_i, item.value.sub(/[N]/, '-').to_i]  }
      # if not seq_num or seq_num == "0000"
      if true
        datapoints = self.points.desc(:date_int).limit(points_num).map { | item | [item.date_int.to_i, item.value.sub(/[N]/, '-').to_i]  }
        datapoints = datapoints.reverse
        # datapoints << self.data_points.to_s
      # else
        # datapoints = self.points.where(:seq_num.gt => seq_num.to_i).asc(:date_int).map { | item | [item.date_int.to_i, item.value.sub(/[N]/, '-').to_i] }
      end
      return datapoints
    end

    def get_mobile_points
      points_num = MOBILE_POINTS_NUM ? MOBILE_POINTS_NUM : 20
      datapoints = []
      datapoints = self.points.desc(:seq_num).limit(points_num).map { | item | [item.date_int, item.value.sub(/[N]/, '-')] }      
      return datapoints
    end

    def add_point(data_value)
      if data_value.split('-').length > 1
        data = data_value.split('-')[0]
        data_time = data_value.split('-')[1]
        # data_int = TEAUTIL.get_date_seconds(data_time)
        data_int = data_time
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
      point_last = self.points.desc(:date_int).first
      if point_last and point_last.seq_num
        seq_num = point_last.seq_num
      end
      return seq_num
    end

    def update_expression( exp_string )
      if exp_string =~ /[+-]{1}[0-9]{1,2}/
        self.update_attributes(:exp_str => exp_string)
      end
    end

  private
    def setup_device_user_id
      device_user_id = Device.find(self.device_id)
      self.device_user_id = device_user_id.device_id
    end
end
