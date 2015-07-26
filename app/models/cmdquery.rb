class Cmdquery
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :device_id, type: String
  field :device_user_id, type: String
  field :channel_id, type: String
  field :channel_user_id, type: String
  field :value, type: String
  field :send_flag, type: String
  field :send_request_flag, type: String
  field :seq_num, type: Integer

  belongs_to :device
  belongs_to :channel

  before_create :set_params
  # before_create :number_to_16
  # before_create :set_default_send_flag

  scope :wait_for_send, -> { where( send_flag: 'N') }
  scope :wait_for_request, -> { where( send_request_flag: 'Y') }

  public
    def get_command
      self.channel_user_id + "-" + self.value
    end

    def request_command
      self.channel_user_id + "-?"
    end

  private 
    def set_params
      number_to_16
      set_seq_num
    end

    def number_to_16
      channel = Channel.find(self.channel_id)
      if channel.channel_type == "3"
        # self.value = self.value.strip.gsub(' ', 'H') + "H"
        self.value = self.value.strip.gsub(' ', '')
      end
      self.send_flag = 'N'
      self.send_request_flag = 'N'
    end

    def set_seq_num
      cmd = Cmdquery.last
      if cmd and cmd.seq_num
        self.seq_num = cmd.seq_num + 1
      else
        self.seq_num = 1
      end
    end

    def set_default_send_flag
      self.send_flag = 'N'
    end
end
