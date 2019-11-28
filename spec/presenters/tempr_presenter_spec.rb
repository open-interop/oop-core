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
              temprs: []
            ]
          )
        )
      end
    end

    context 'tempr with children' do
      let!(:sub_tempr) { FactoryBot.create(:tempr, tempr: tempr) }

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
                temprs:
                  tempr.temprs.map do |t|
                    {
                      id: t.id,
                      deviceId: device.id,
                      name: t.name,
                      endpointType: t.endpoint_type,
                      queueRequest: t.queue_request,
                      queueResponse: t.queue_response,
                      template:
                        t.template.transform_keys do |k|
                          k.to_s.camelcase(:lower)
                        end,
                      createdAt: t.created_at,
                      updatedAt: t.updated_at,
                      temprs: []
                    }
                  end
              }
            ]
          )
        )
      end
    end
  end
end
