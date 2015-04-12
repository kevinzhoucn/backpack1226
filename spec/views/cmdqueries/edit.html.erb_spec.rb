require 'rails_helper'

RSpec.describe "cmdqueries/edit", :type => :view do
  before(:each) do
    @cmdquery = assign(:cmdquery, Cmdquery.create!(
      :device_id => "MyString",
      :channel_id => "MyString",
      :value => "MyString"
    ))
  end

  it "renders the edit cmdquery form" do
    render

    assert_select "form[action=?][method=?]", cmdquery_path(@cmdquery), "post" do

      assert_select "input#cmdquery_device_id[name=?]", "cmdquery[device_id]"

      assert_select "input#cmdquery_channel_id[name=?]", "cmdquery[channel_id]"

      assert_select "input#cmdquery_value[name=?]", "cmdquery[value]"
    end
  end
end
