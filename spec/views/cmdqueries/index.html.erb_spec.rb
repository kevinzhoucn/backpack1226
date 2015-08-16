require 'rails_helper'

RSpec.describe "cmdqueries/index", :type => :view do
  before(:each) do
    assign(:cmdqueries, [
      Cmdquery.create!(
        :device_id => "Device",
        :channel_id => "Channel",
        :value => "Value"
      ),
      Cmdquery.create!(
        :device_id => "Device",
        :channel_id => "Channel",
        :value => "Value"
      )
    ])
  end

  it "renders a list of cmdqueries" do
    render
    assert_select "tr>td", :text => "Device".to_s, :count => 2
    assert_select "tr>td", :text => "Channel".to_s, :count => 2
    assert_select "tr>td", :text => "Value".to_s, :count => 2
  end
end
