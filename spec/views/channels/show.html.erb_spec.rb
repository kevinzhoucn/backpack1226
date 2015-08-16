require 'rails_helper'

RSpec.describe "channels/show", :type => :view do
  before(:each) do
    @channel = assign(:channel, Channel.create!(
      :title => "Title",
      :channel_type => "Channel Type",
      :channel_name => "Channel Name",
      :device_id => "Device",
      :user_id => "User"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/Channel Type/)
    expect(rendered).to match(/Channel Name/)
    expect(rendered).to match(/Device/)
    expect(rendered).to match(/User/)
  end
end
