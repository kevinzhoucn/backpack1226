require 'rails_helper'

RSpec.describe "points/edit", :type => :view do
  before(:each) do
    @point = assign(:point, Point.create!(
      :value => "MyString",
      :seq_num => "MyString"
    ))
  end

  it "renders the edit point form" do
    render

    assert_select "form[action=?][method=?]", point_path(@point), "post" do

      assert_select "input#point_value[name=?]", "point[value]"

      assert_select "input#point_seq_num[name=?]", "point[seq_num]"
    end
  end
end
