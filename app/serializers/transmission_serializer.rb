# frozen_string_literal: true

class TransmissionSerializer < ActiveModel::Serializer
  attributes :id, :device_id, :device_tempr_id,
             :message_uuid, :transmission_uuid, :success,
             :status, :transmitted_at, :body,
             :created_at, :updated_at
end
