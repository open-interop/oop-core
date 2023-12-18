# frozen_string_literal: true

class TemprPresenter < BasePresenter
  attributes :id, :device_group_id, :tempr_id, :name,
             :description, :endpoint_type,
             :queue_request, :queue_response, :save_console,
             :template, :example_transmission, :notes,
             :created_at, :updated_at

  def self.record_for_microservices(parent_id, record, parent_type)
    return if record.blank?

    device_id = parent_id
    schedule_id = nil

    if parent_type == :schedule
      device_id = nil
      schedule_id = parent_id
    end

    {
      id: record.id,
      deviceId: device_id,
      scheduleId: schedule_id,
      name: record.name,
      endpointType: record.endpoint_type,
      queueRequest: record.queue_request,
      queueResponse: record.queue_response,
      saveConsole: record.save_console,
      layers: LayerPresenter.record_for_microservices(record.layers),
      template: record.template,
      createdAt: record.created_at,
      updatedAt: record.updated_at,
      temprs: record.temprs.map do |tempr|
        record_for_microservices(parent_id, tempr, parent_type)
      end
    }
  end

  def self.collection_for_microservices(parent_id, records, parent_type = :device)
    {
      ttl: Rails.configuration.oop[:tempr_cache_ttl],
      data: records.map do |record|
        record_for_microservices(parent_id, record, parent_type)
      end
    }
  end
end
