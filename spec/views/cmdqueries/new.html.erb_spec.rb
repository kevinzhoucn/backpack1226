require 'rails_helper'

RSpec.describe "cmdqueries/new", :type => :view do
  before(:each) do
    assign(:cmdquery, Cmdquery.new(
      :device_id => "MyString",
      :channel_id => "MyString",
      :value => "MyString"
    ))
  end

  it "renders new cmdquery form" do
    render

    assert_select "form[action=?][method=?]", cmdqueries_path, "post" do

      assert_select "input#cmdquery_device_id[name=?]", "cmdquery[device_id]"

      assert_select "input#cmdquery_channel_id[name=?]", "cmdquery[channel_id]"

      assert_select "input#cmdquery_value[name=?]", "cmdquery[value]"
    end
  end
end
