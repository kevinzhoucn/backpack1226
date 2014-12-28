require 'rails_helper'

RSpec.describe "cpanel/site_configs/edit", :type => :view do
  before(:each) do
    @cpanel_site_config = assign(:cpanel_site_config, Cpanel::SiteConfig.create!(
      :key => "MyString",
      :value => "MyString"
    ))
  end

  it "renders the edit cpanel_site_config form" do
    render

    assert_select "form[action=?][method=?]", cpanel_site_config_path(@cpanel_site_config), "post" do

      assert_select "input#cpanel_site_config_key[name=?]", "cpanel_site_config[key]"

      assert_select "input#cpanel_site_config_value[name=?]", "cpanel_site_config[value]"
    end
  end
end
