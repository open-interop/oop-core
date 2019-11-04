class TemprPresenter < BasePresenter
  attributes :id, :device_group_id, :name,
             :description, :endpoint_type,
             :queue_request, :queue_response, :template, :created_at, :updated_at

  def self.collection_for_microservices(device_id, records)
    {
      ttl: 10_000,
      data: records.map do |record|
        {
          id: record.id,
          deviceId: device_id,
          name: record.name,
          endpointType: record.endpoint_type,
          queueRequest: record.queue_request,
          queueResponse: record.queue_response,
          template: record.template,
          createdAt: record.created_at,
          updatedAt: record.updated_at
        }
      end
    }
  end
end
