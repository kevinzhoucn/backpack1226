require "rails_helper"

RSpec.describe CmdqueriesController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/cmdqueries").to route_to("cmdqueries#index")
    end

    it "routes to #new" do
      expect(:get => "/cmdqueries/new").to route_to("cmdqueries#new")
    end

    it "routes to #show" do
      expect(:get => "/cmdqueries/1").to route_to("cmdqueries#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/cmdqueries/1/edit").to route_to("cmdqueries#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/cmdqueries").to route_to("cmdqueries#create")
    end

    it "routes to #update" do
      expect(:put => "/cmdqueries/1").to route_to("cmdqueries#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/cmdqueries/1").to route_to("cmdqueries#destroy", :id => "1")
    end

  end
end
