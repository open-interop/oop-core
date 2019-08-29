# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::DevicesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/devices').to route_to('devices#index')
    end

    it 'routes to #show' do
      expect(get: '/api/v1/devices/1').to route_to('devices#show', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/api/v1/devices').to route_to('devices#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/api/v1/devices/1').to route_to('devices#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/api/v1/devices/1').to route_to('devices#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/api/v1/devices/1').to(
        route_to('devices#destroy', id: '1')
      )
    end
  end
end
