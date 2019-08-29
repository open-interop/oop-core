require "rails_helper"

RSpec.describe TemprsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/temprs").to route_to("temprs#index")
    end

    it "routes to #show" do
      expect(:get => "/temprs/1").to route_to("temprs#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/temprs").to route_to("temprs#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/temprs/1").to route_to("temprs#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/temprs/1").to route_to("temprs#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/temprs/1").to route_to("temprs#destroy", :id => "1")
    end
  end
end
