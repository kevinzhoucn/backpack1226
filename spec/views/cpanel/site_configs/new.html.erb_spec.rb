require 'rails_helper'

RSpec.describe "cpanel/site_configs/new", :type => :view do
  before(:each) do
    assign(:cpanel_site_config, Cpanel::SiteConfig.new(
      :key => "MyString",
      :value => "MyString"
    ))
  end

  it "renders new cpanel_site_config form" do
    render

    assert_select "form[action=?][method=?]", cpanel_site_configs_path, "post" do

      assert_select "input#cpanel_site_config_key[name=?]", "cpanel_site_config[key]"

      assert_select "input#cpanel_site_config_value[name=?]", "cpanel_site_config[value]"
    end
  end
end
