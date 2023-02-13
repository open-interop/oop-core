# frozen_string_literal: true

class TransmissionPresenter < BasePresenter
  attributes :id, :message_id, :device_id, :tempr_id, :schedule_id,
             :message_uuid, :transmission_uuid, :success,
             :status, :state, :discarded, :transmitted_at, :response_body,
             :request_body, :created_at, :updated_at, :custom_field_a, :custom_field_b
end
