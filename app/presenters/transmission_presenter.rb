# frozen_string_literal: true

class TransmissionPresenter < BasePresenter
  attributes :id, :device_id, :tempr_id, :schedule_id ,
             :message_uuid, :transmission_uuid, :success,
             :status, :transmitted_at, :response_body, :request_body,
             :created_at, :updated_at
end
