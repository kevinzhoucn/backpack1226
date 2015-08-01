require 'rails_helper'

RSpec.describe "channels/new", :type => :view do
  before(:each) do
    assign(:channel, Channel.new(
      :title => "MyString",
      :channel_type => "MyString",
      :channel_name => "MyString",
      :device_id => "MyString",
      :user_id => "MyString"
    ))
  end

  it "renders new channel form" do
    render

    assert_select "form[action=?][method=?]", channels_path, "post" do

      assert_select "input#channel_title[name=?]", "channel[title]"

      assert_select "input#channel_channel_type[name=?]", "channel[channel_type]"

      assert_select "input#channel_channel_name[name=?]", "channel[channel_name]"

      assert_select "input#channel_device_id[name=?]", "channel[device_id]"

      assert_select "input#channel_user_id[name=?]", "channel[user_id]"
    end
  end
end
