class Cmdquerystatus
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :device

  field :device_id, type: String
  field :seq_num, type: Integer
  field :status, type: String

  default_scope -> { desc(:created_at) }
end
