require 'rails_helper'

RSpec.describe Api::V1::TransmissionsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(:get => '/api/v1/transmissions').to route_to('api/v1/transmissions#index')
    end
  end
end
