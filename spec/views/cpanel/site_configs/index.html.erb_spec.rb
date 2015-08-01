require 'rails_helper'

RSpec.describe "cpanel/site_configs/index", :type => :view do
  before(:each) do
    assign(:cpanel_site_configs, [
      Cpanel::SiteConfig.create!(
        :key => "Key",
        :value => "Value"
      ),
      Cpanel::SiteConfig.create!(
        :key => "Key",
        :value => "Value"
      )
    ])
  end

  it "renders a list of cpanel/site_configs" do
    render
    assert_select "tr>td", :text => "Key".to_s, :count => 2
    assert_select "tr>td", :text => "Value".to_s, :count => 2
  end
end
