require 'rails_helper'

RSpec.describe "devices/new", :type => :view do
  before(:each) do
    assign(:device, Device.new(
      :device_id => "MyString",
      :device_name => "MyString",
      :device_description => "MyString",
      :model_id => "MyString",
      :model_key => "MyString",
      :model_name => "MyString",
      :model_description => "MyString",
      :location_local => "MyString",
      :location_latitude => "MyString",
      :location_longitude => "MyString",
      :uid => "MyString"
    ))
  end

  it "renders new device form" do
    render

    assert_select "form[action=?][method=?]", devices_path, "post" do

      assert_select "input#device_device_id[name=?]", "device[device_id]"

      assert_select "input#device_device_name[name=?]", "device[device_name]"

      assert_select "input#device_device_description[name=?]", "device[device_description]"

      assert_select "input#device_model_id[name=?]", "device[model_id]"

      assert_select "input#device_model_key[name=?]", "device[model_key]"

      assert_select "input#device_model_name[name=?]", "device[model_name]"

      assert_select "input#device_model_description[name=?]", "device[model_description]"

      assert_select "input#device_location_local[name=?]", "device[location_local]"

      assert_select "input#device_location_latitude[name=?]", "device[location_latitude]"

      assert_select "input#device_location_longitude[name=?]", "device[location_longitude]"

      assert_select "input#device_uid[name=?]", "device[uid]"
    end
  end
end
