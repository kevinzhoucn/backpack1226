require 'rails_helper'

RSpec.describe "points/index", :type => :view do
  before(:each) do
    assign(:points, [
      Point.create!(
        :value => "Value",
        :seq_num => "Seq Num"
      ),
      Point.create!(
        :value => "Value",
        :seq_num => "Seq Num"
      )
    ])
  end

  it "renders a list of points" do
    render
    assert_select "tr>td", :text => "Value".to_s, :count => 2
    assert_select "tr>td", :text => "Seq Num".to_s, :count => 2
  end
end
