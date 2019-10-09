require 'rails_helper'

RSpec.describe Api::V1::DeviceTemprsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/device_groups/1/device_temprs').to route_to('api/v1/device_temprs#index', device_group_id: '1')
    end

    it 'routes to #show' do
      expect(get: '/api/v1/device_groups/1/device_temprs/1').to route_to('api/v1/device_temprs#show', id: '1', device_group_id: '1')
    end

    it 'routes to #create' do
      expect(post: '/api/v1/device_groups/1/device_temprs').to route_to('api/v1/device_temprs#create', device_group_id: '1')
    end

    it 'routes to #update via PUT' do
      expect(put: '/api/v1/device_groups/1/device_temprs/1').to route_to('api/v1/device_temprs#update', id: '1', device_group_id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/api/v1/device_groups/1/device_temprs/1').to route_to('api/v1/device_temprs#update', id: '1', device_group_id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/api/v1/device_groups/1/device_temprs/1').to route_to('api/v1/device_temprs#destroy', :id => '1', device_group_id: '1')
    end
  end
end
