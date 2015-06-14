class Cmdquery
  include Mongoid::Document
  field :device_id, type: String
  field :device_user_id, type: String
  field :channel_id, type: String
  field :channel_user_id, type: String
  field :value, type: String
  field :send_flag, type: String
  field :send_request_flag, type: String

  belongs_to :device
  belongs_to :channel

  before_create :number_to_16
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
    def number_to_16
      channel = Channel.find(self.channel_id)
      if channel.channel_type == "3"
        # self.value = self.value.strip.gsub(' ', 'H') + "H"
        self.value = self.value.strip.gsub(' ', '')
      end
      self.send_flag = 'N'
      self.send_request_flag = 'N'
    end

    def set_default_send_flag
      self.send_flag = 'N'
    end
end
