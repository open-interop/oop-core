require 'rails_helper'

RSpec.describe TemprPresenter do
  describe '::collection_for_microservices' do
    let!(:device_tempr) { FactoryBot.create(:device_tempr) }
    let(:device) { device_tempr.device }
    let(:tempr) { device_tempr.tempr }

    let(:collection) do
      described_class.collection_for_microservices(
        device.id,
        [tempr]
      )
    end

    context 'tempr with no children' do
      it do
        expect(collection).to(
          eq(
            ttl: 10_000,
            data: [
              {
                id: tempr.id,
                deviceId: device.id,
                name: tempr.name,
                endpointType: tempr.endpoint_type,
                queueRequest: tempr.queue_request,
                queueResponse: tempr.queue_response,
                template:
                  tempr.template.transform_keys do |k|
                    k.to_s.camelcase(:lower)
                  end,
                createdAt: tempr.created_at,
                updatedAt: tempr.updated_at,
                tempr: nil
              }
            ]
          )
        )
      end
    end

    context 'tempr with children' do
      let!(:chained_tempr) { FactoryBot.create(:tempr, tempr: tempr) }

      it do
        expect(collection).to(
          eq(
            ttl: 10_000,
            data: [
              {
                id: tempr.id,
                deviceId: device.id,
                name: tempr.name,
                endpointType: tempr.endpoint_type,
                queueRequest: tempr.queue_request,
                queueResponse: tempr.queue_response,
                template:
                  tempr.template.transform_keys do |k|
                    k.to_s.camelcase(:lower)
                  end,
                createdAt: tempr.created_at,
                updatedAt: tempr.updated_at,
                tempr: {
                  id: chained_tempr.id,
                  deviceId: device.id,
                  name: chained_tempr.name,
                  endpointType: chained_tempr.endpoint_type,
                  queueRequest: chained_tempr.queue_request,
                  queueResponse: chained_tempr.queue_response,
                  template:
                    chained_tempr.template.transform_keys do |k|
                      k.to_s.camelcase(:lower)
                    end,
                  createdAt: chained_tempr.created_at,
                  updatedAt: chained_tempr.updated_at,
                  tempr: nil
                }
              }
            ]
          )
        )
      end
    end
  end
end
