require 'rails_helper'

RSpec.describe "channels/edit", :type => :view do
  before(:each) do
    @channel = assign(:channel, Channel.create!(
      :title => "MyString",
      :channel_type => "MyString",
      :channel_name => "MyString",
      :device_id => "MyString",
      :user_id => "MyString"
    ))
  end

  it "renders the edit channel form" do
    render

    assert_select "form[action=?][method=?]", channel_path(@channel), "post" do

      assert_select "input#channel_title[name=?]", "channel[title]"

      assert_select "input#channel_channel_type[name=?]", "channel[channel_type]"

      assert_select "input#channel_channel_name[name=?]", "channel[channel_name]"

      assert_select "input#channel_device_id[name=?]", "channel[device_id]"

      assert_select "input#channel_user_id[name=?]", "channel[user_id]"
    end
  end
end
