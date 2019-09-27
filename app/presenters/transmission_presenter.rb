# frozen_string_literal: true

class TransmissionPresenter < BasePresenter
  attributes :id, :device_id, :device_tempr_id,
             :message_uuid, :transmission_uuid, :success,
             :status, :transmitted_at, :body,
             :created_at, :updated_at
end
