json.array!(@cmdqueries) do |cmdquery|
  json.extract! cmdquery, :id, :device_id, :channel_id, :value
  json.url cmdquery_url(cmdquery, format: :json)
end
