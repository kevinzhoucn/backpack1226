class Device
  include Mongoid::Document
  field :device_id, type: String
  field :device_name, type: String
  field :device_description, type: String
  field :device_model_id, type: String
  field :device_model_key, type: String
  field :device_model_name, type: String
  field :device_model_description, type: String
  field :device_location_local, type: String
  field :device_location_latitude, type: String
  field :device_location_longitude, type: String
  field :device_uid, type: String
end
