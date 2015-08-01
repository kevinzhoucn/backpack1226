require 'rails_helper'

RSpec.describe "cmdqueries/show", :type => :view do
  before(:each) do
    @cmdquery = assign(:cmdquery, Cmdquery.create!(
      :device_id => "Device",
      :channel_id => "Channel",
      :value => "Value"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Device/)
    expect(rendered).to match(/Channel/)
    expect(rendered).to match(/Value/)
  end
end
