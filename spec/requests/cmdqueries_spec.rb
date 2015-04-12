require 'rails_helper'

RSpec.describe "Cmdqueries", :type => :request do
  describe "GET /cmdqueries" do
    it "works! (now write some real specs)" do
      get cmdqueries_path
      expect(response).to have_http_status(200)
    end
  end
end
