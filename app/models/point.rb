class Point
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :value, type: String
  field :date_str, type: String
  field :date_int, type: String
  field :seq_num, type: Integer
  field :channel_id, type: String

  belongs_to :channel

  scope :seg, ->(start_time, end_time){ where(:date_int.gte => start_time, :data_int.lte => end_time) }

  def apply_expression
    channel = self.channel
    exp_str = channel.exp_str
  end
end
