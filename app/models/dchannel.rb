class Dchannel
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :dmodelchannel
  belongs_to :dmodel

  # has_many :points
  # has_many :dmodelchannels

  field :cid, type: Integer #user define channel id 0 ~ 255
  field :offset, type: Integer
  field :name, type: String
  field :description, type: String
  field :dmodel_id, type: String
  field :dmodelchannel_id, type: String
  field :dgroup, type: String

  validates_presence_of :cid, :name, :description

  scope :recent, -> { desc(:created_at) }
  scope :d_input, -> { where(:offset => 0) }
  scope :d_output, -> { where(:offset => 32) }
  scope :a_input, -> { where(:offset => 64) }
  scope :a_output, -> { where(:offset => 96) }

  public 
    def show_id
      self.cid - self.offset
    end

    def isinput?
      self.offset == 0 or self.offset == 64
    end

    def isdoutput?
      self.offset == 32
    end

    def isaoutput?
      self.offset == 96
    end
end