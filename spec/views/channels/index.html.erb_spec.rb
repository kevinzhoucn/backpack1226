require 'rails_helper'

RSpec.describe "channels/index", :type => :view do
  before(:each) do
    assign(:channels, [
      Channel.create!(
        :title => "Title",
        :channel_type => "Channel Type",
        :channel_name => "Channel Name",
        :device_id => "Device",
        :user_id => "User"
      ),
      Channel.create!(
        :title => "Title",
        :channel_type => "Channel Type",
        :channel_name => "Channel Name",
        :device_id => "Device",
        :user_id => "User"
      )
    ])
  end

  it "renders a list of channels" do
    render
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "Channel Type".to_s, :count => 2
    assert_select "tr>td", :text => "Channel Name".to_s, :count => 2
    assert_select "tr>td", :text => "Device".to_s, :count => 2
    assert_select "tr>td", :text => "User".to_s, :count => 2
  end
end
