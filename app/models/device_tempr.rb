# frozen_string_literal: true

# Methods relating to the device tempr,
# this is the join table between device and tempr
class DeviceTempr < ApplicationRecord
  #
  # Validations
  #
  validates :endpoint_type, presence: true
  validates :queue_response, inclusion: { in: [true, false] }
  validates :options, presence: true

  #
  # Relationships
  #
  belongs_to :device
  belongs_to :tempr

  #
  # Serializations
  #
  serialize :options, Hash

  def as_json(_options = {})
    {
      id: id,
      deviceId: device_id,
      temprId: tempr_id,
      endpointType: endpoint_type,
      queueResponse: queue_response,
      template: template,
      createdAt: created_at,
      updatedAt: created_at
    }
  end

  def template
    @template ||= begin
      options.tap do |h|
        h[:body] = tempr&.body
      end
    end
  end
end
