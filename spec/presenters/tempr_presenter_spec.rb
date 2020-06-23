require 'rails_helper'

RSpec.describe TemprPresenter do
  describe '::collection_for_microservices' do
    context 'Device' do
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
              ttl: Rails.configuration.oop[:tempr_cache_ttl],
              data: [
                id: tempr.id,
                deviceId: device.id,
                scheduleId: nil,
                name: tempr.name,
                endpointType: tempr.endpoint_type,
                queueRequest: tempr.queue_request,
                queueResponse: tempr.queue_response,
                layers: [],
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
              ttl: Rails.configuration.oop[:tempr_cache_ttl],
              data: [
                {
                  id: tempr.id,
                  deviceId: device.id,
                  scheduleId: nil,
                  name: tempr.name,
                  endpointType: tempr.endpoint_type,
                  queueRequest: tempr.queue_request,
                  queueResponse: tempr.queue_response,
                  layers: [],
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
                        scheduleId: nil,
                        name: t.name,
                        endpointType: t.endpoint_type,
                        queueRequest: t.queue_request,
                        queueResponse: t.queue_response,
                        layers: [],
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

      context 'with layers' do
        let(:layer1) { FactoryBot.create(:layer, account: device.account) }
        let(:layer2) do
          FactoryBot.create(:layer, reference: 'reference2', account: device.account)
        end

        let(:layers) { [layer1, layer2] }

        before do
          FactoryBot.create(:tempr_layer, layer: layer1, tempr: tempr)
          FactoryBot.create(:tempr_layer, layer: layer2, tempr: tempr)
        end

        context 'tempr with no children' do
          it do
            expect(collection).to(
              eq(
                ttl: Rails.configuration.oop[:tempr_cache_ttl],
                data: [
                  id: tempr.id,
                  deviceId: device.id,
                  scheduleId: nil,
                  name: tempr.name,
                  endpointType: tempr.endpoint_type,
                  queueRequest: tempr.queue_request,
                  queueResponse: tempr.queue_response,
                  layers: [
                    {
                      id: layer1.id,
                      reference: layer1.reference,
                      script: layer1.script
                    },
                    {
                      id: layer2.id,
                      reference: layer2.reference,
                      script: layer2.script
                    }
                  ],
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
                ttl: Rails.configuration.oop[:tempr_cache_ttl],
                data: [
                  {
                    id: tempr.id,
                    deviceId: device.id,
                    scheduleId: nil,
                    name: tempr.name,
                    endpointType: tempr.endpoint_type,
                    queueRequest: tempr.queue_request,
                    queueResponse: tempr.queue_response,
                    layers:  [
                      {
                        id: layer1.id,
                        reference: layer1.reference,
                        script: layer1.script
                      },
                      {
                        id: layer2.id,
                        reference: layer2.reference,
                        script: layer2.script
                      }
                    ],
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
                          scheduleId: nil,
                          name: t.name,
                          endpointType: t.endpoint_type,
                          queueRequest: t.queue_request,
                          queueResponse: t.queue_response,
                          layers: [],
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

    context 'Schedule' do
      let!(:schedule_tempr) { FactoryBot.create(:schedule_tempr) }
      let(:schedule) { schedule_tempr.schedule }
      let(:tempr) { schedule_tempr.tempr }

      let(:collection) do
        described_class.collection_for_microservices(
          schedule.id,
          [tempr],
          :schedule
        )
      end

      context 'tempr with no children' do
        it do
          expect(collection).to(
            eq(
              ttl: Rails.configuration.oop[:tempr_cache_ttl],
              data: [
                id: tempr.id,
                deviceId: nil,
                scheduleId: schedule.id,
                name: tempr.name,
                endpointType: tempr.endpoint_type,
                queueRequest: tempr.queue_request,
                queueResponse: tempr.queue_response,
                layers: [],
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
              ttl: Rails.configuration.oop[:tempr_cache_ttl],
              data: [
                {
                  id: tempr.id,
                  deviceId: nil,
                  scheduleId: schedule.id,
                  name: tempr.name,
                  endpointType: tempr.endpoint_type,
                  queueRequest: tempr.queue_request,
                  queueResponse: tempr.queue_response,
                  layers: [],
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
                        deviceId: nil,
                        scheduleId: schedule.id,
                        name: t.name,
                        endpointType: t.endpoint_type,
                        queueRequest: t.queue_request,
                        queueResponse: t.queue_response,
                        layers: [],
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
end
