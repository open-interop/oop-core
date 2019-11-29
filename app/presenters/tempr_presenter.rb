# frozen_string_literal: true

class TemprPresenter < BasePresenter
  attributes :id, :device_group_id, :tempr_id, :name,
             :description, :endpoint_type,
             :queue_request, :queue_response, :template,
             :example_transmission, :notes,
             :created_at, :updated_at

  def self.record_for_microservice(device_id, record)
    return if record.blank?

    {
      id: record.id,
      deviceId: device_id,
      name: record.name,
      endpointType: record.endpoint_type,
      queueRequest: record.queue_request,
      queueResponse: record.queue_response,
      template:
        record.template.transform_keys do |k|
          k.to_s.camelcase(:lower)
        end,
      createdAt: record.created_at,
      updatedAt: record.updated_at,
      temprs: record.temprs.map do |tempr|
        record_for_microservice(device_id, tempr)
      end
    }
  end

  def self.collection_for_microservices(device_id, records)
    {
      ttl: 10_000,
      data: records.map do |record|
        record_for_microservice(device_id, record)
      end
    }
  end
end
