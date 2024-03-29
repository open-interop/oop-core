# frozen_string_literal: true

class MessagePresenter < BasePresenter
  attributes :id, :device_id, :schedule_id, :origin_id, :origin_type, :ip_address,
             :uuid, :body, :transmission_count, :created_at, :updated_at, :state,
             :custom_field_a, :custom_field_b, :retried_at, :retried

  def self.record_for_microservices(record)
    {
        uuid: SecureRandom.uuid,
        message: record.body,
        device: DevicePresenter.record_for_microservices(record.device)
    }
  end
end
