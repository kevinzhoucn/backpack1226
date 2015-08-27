require 'rails_helper'

RSpec.describe "points/show", :type => :view do
  before(:each) do
    @point = assign(:point, Point.create!(
      :value => "Value",
      :seq_num => "Seq Num"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Value/)
    expect(rendered).to match(/Seq Num/)
  end
end
