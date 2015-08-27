require 'rails_helper'

RSpec.describe "points/new", :type => :view do
  before(:each) do
    assign(:point, Point.new(
      :value => "MyString",
      :seq_num => "MyString"
    ))
  end

  it "renders new point form" do
    render

    assert_select "form[action=?][method=?]", points_path, "post" do

      assert_select "input#point_value[name=?]", "point[value]"

      assert_select "input#point_seq_num[name=?]", "point[seq_num]"
    end
  end
end
