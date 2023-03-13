# frozen_string_literal: true

class TransmissionPresenter < BasePresenter
  attributes :id, :message_id, :device_id, :tempr_id, :schedule_id,
             :message_uuid, :transmission_uuid, :success,
             :status, :state, :discarded, :transmitted_at, :response_body,
             :request_body, :created_at, :updated_at, :custom_field_a,
             :custom_field_b, :retried_at, :retried

  def self.record_for_microservices(record)
    hash_for_microservice = {
        uuid: record.message.uuid,
        message: record.message.body,
        transmissionId: SecureRandom.uuid
    }

    if record.device.present?
      hash_for_microservice[:device] =
        DevicePresenter.record_for_microservices(record.device)
      parent_id = record.device_id
      parent_type = :device
    elsif record.schedule.present?
      hash_for_microservice[:schedule] =
        SchedulePresenter.record_for_microservices(record.schedule)
      parent_id = record.schedule_id
      parent_type = :schedule
    end

    hash_for_microservice[:tempr] =
      TemprPresenter.record_for_microservices(parent_id, record.tempr, parent_type)

    hash_for_microservice[:tempr][:rendered] = {
      host: record.request_host,
      port: record.request_port,
      path: record.request_path,
      protocol: record.request_protocol,
      requestMethod: record.request_method,
      headers: JSON.parse(record.request_headers),
      body: JSON.parse(record.request_body)
    }

    hash_for_microservice[:tempr][:console] = ""
    hash_for_microservice[:tempr][:error] = nil

    hash_for_microservice
  end
end
