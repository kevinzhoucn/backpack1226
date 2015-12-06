class Point
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :value, type: String
  field :date_str, type: String
  field :date_int, type: String
  field :seq_num, type: Integer
  field :channel_id, type: String
  field :devicechannel_id, type: String

  belongs_to :channel

  belongs_to :devicechannel

  scope :seg, ->(start_time, end_time){ where(:date_int.gte => start_time, :data_int.lte => end_time) }

  def apply_expression
    ret = 0
    channel = self.channel
    # exp_str = channel.exp_str
    exp_str = '/3'
    # if exp_str =~ /[^\\+\\-\\*\\%]{1}[0-9]{1,2}/
    exp_exp = exp_str[0]
    exp_value = exp_str[1, exp_str.length]

    original_value = self.value.to_i

    case exp_exp
    when '+'
      ret = original_value + exp_value.to_i
    when '-'
      ret = original_value - exp_value.to_i
    when '*'
      ret = original_value * exp_value.to_i
    when '/'
      ret = original_value / exp_value.to_i
    else 
      ret = original_value
    end
    return ret.to_s
  end
end
