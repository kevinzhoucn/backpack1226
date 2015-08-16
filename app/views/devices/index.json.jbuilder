json.array!(@devices) do |device|
  json.extract! device, :id, :device_id, :device_name, :device_description, :model_id, :model_key, :model_name, :model_description, :location_local, :location_latitude, :location_longitude, :uid
  json.url device_url(device, format: :json)
end
