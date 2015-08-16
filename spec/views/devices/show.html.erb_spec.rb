require 'rails_helper'

RSpec.describe "devices/show", :type => :view do
  before(:each) do
    @device = assign(:device, Device.create!(
      :device_id => "Device",
      :device_name => "Device Name",
      :device_description => "Device Description",
      :model_id => "Model",
      :model_key => "Model Key",
      :model_name => "Model Name",
      :model_description => "Model Description",
      :location_local => "Location Local",
      :location_latitude => "Location Latitude",
      :location_longitude => "Location Longitude",
      :uid => "Uid"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Device/)
    expect(rendered).to match(/Device Name/)
    expect(rendered).to match(/Device Description/)
    expect(rendered).to match(/Model/)
    expect(rendered).to match(/Model Key/)
    expect(rendered).to match(/Model Name/)
    expect(rendered).to match(/Model Description/)
    expect(rendered).to match(/Location Local/)
    expect(rendered).to match(/Location Latitude/)
    expect(rendered).to match(/Location Longitude/)
    expect(rendered).to match(/Uid/)
  end
end
