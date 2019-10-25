# frozen_string_literal: true

class DeviceTemprPresenter < BasePresenter
  attributes :id, :device_id, :tempr_id, :endpoint_type,
             :queue_response, :template, :created_at, :updated_at

  def self.collection_for_microservices(records)
    {
      ttl: 10_000,
      data: records.map do |record|
        {
          id: record.id,
          deviceId: record.device_id,
          temprId: record.tempr_id,
          name: record.name,
          endpointType: record.endpoint_type,
          queueResponse: record.queue_response,
          template: record.template,
          createdAt: record.created_at,
          updatedAt: record.updated_at
        }
      end
    }
  end
end
