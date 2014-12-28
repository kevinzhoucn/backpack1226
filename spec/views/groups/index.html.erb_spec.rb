require 'rails_helper'

RSpec.describe "groups/index", :type => :view do
  before(:each) do
    assign(:groups, [
      Group.create!(
        :title => "Title",
        :description => "Description",
        :url => "Url"
      ),
      Group.create!(
        :title => "Title",
        :description => "Description",
        :url => "Url"
      )
    ])
  end

  it "renders a list of groups" do
    render
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => "Url".to_s, :count => 2
  end
end
