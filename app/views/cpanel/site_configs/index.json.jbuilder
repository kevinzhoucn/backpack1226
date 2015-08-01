json.array!(@cpanel_site_configs) do |cpanel_site_config|
  json.extract! cpanel_site_config, :id, :key, :value
  json.url cpanel_site_config_url(cpanel_site_config, format: :json)
end
