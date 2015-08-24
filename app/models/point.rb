class Point
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :value, type: String
  field :date_str, type: String
  field :date_int, type: String
  field :seq_num, type: Integer
  field :channel_id, type: String

  belongs_to :channel
end
