require "rails_helper"

RSpec.describe DeviceTemprsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/device_temprs").to route_to("device_temprs#index")
    end

    it "routes to #show" do
      expect(:get => "/device_temprs/1").to route_to("device_temprs#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/device_temprs").to route_to("device_temprs#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/device_temprs/1").to route_to("device_temprs#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/device_temprs/1").to route_to("device_temprs#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/device_temprs/1").to route_to("device_temprs#destroy", :id => "1")
    end
  end
end
