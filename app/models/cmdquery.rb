class Cmdquery
  include Mongoid::Document
  field :device_id, type: String
  field :device_user_id, type: String
  field :channel_id, type: String
  field :channel_user_id, type: String
  field :value, type: String
  field :send_flag, type: String

  belongs_to :device
  belongs_to :channel

  before_create :number_to_16

  def get_channel_cmd
    
  end
  private 
    def number_to_16
      channel = Channel.find(self.channel_id)
      if channel.channel_type == "3"
        # self.value = self.value.strip.gsub(' ', 'H') + "H"
        self.value = self.value.strip.gsub(' ', '')
      end
    end
end
