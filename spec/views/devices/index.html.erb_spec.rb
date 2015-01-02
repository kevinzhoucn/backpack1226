require 'rails_helper'

RSpec.describe "devices/index", :type => :view do
  before(:each) do
    assign(:devices, [
      Device.create!(
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
      ),
      Device.create!(
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
      )
    ])
  end

  it "renders a list of devices" do
    render
    assert_select "tr>td", :text => "Device".to_s, :count => 2
    assert_select "tr>td", :text => "Device Name".to_s, :count => 2
    assert_select "tr>td", :text => "Device Description".to_s, :count => 2
    assert_select "tr>td", :text => "Model".to_s, :count => 2
    assert_select "tr>td", :text => "Model Key".to_s, :count => 2
    assert_select "tr>td", :text => "Model Name".to_s, :count => 2
    assert_select "tr>td", :text => "Model Description".to_s, :count => 2
    assert_select "tr>td", :text => "Location Local".to_s, :count => 2
    assert_select "tr>td", :text => "Location Latitude".to_s, :count => 2
    assert_select "tr>td", :text => "Location Longitude".to_s, :count => 2
    assert_select "tr>td", :text => "Uid".to_s, :count => 2
  end
end
