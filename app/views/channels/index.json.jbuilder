json.array!(@channels) do |channel|
  json.extract! channel, :id, :title, :channel_type, :channel_name, :device_id, :user_id
  json.url channel_url(channel, format: :json)
end
