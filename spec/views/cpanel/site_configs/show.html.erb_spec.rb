require 'rails_helper'

RSpec.describe "cpanel/site_configs/show", :type => :view do
  before(:each) do
    @cpanel_site_config = assign(:cpanel_site_config, Cpanel::SiteConfig.create!(
      :key => "Key",
      :value => "Value"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Key/)
    expect(rendered).to match(/Value/)
  end
end
