# frozen_string_literal: true

class MessagePresenter < BasePresenter
  attributes :id, :device_id, :schedule_id, :origin_id, :origin_type,
             :uuid, :body, :created_at, :updated_at
end
