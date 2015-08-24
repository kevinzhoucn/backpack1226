json.array!(@points) do |point|
  json.extract! point, :id, :value, :seq_num
  json.url point_url(point, format: :json)
end
