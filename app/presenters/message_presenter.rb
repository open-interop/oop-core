# frozen_string_literal: true

class MessagePresenter < BasePresenter
  attributes :id, :device_id, :schedule_id, :origin_id, :origin_type, :ip_address,
             :uuid, :body, :transmission_count, :created_at, :updated_at, :state
end
