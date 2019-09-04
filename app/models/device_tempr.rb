# frozen_string_literal: true

# Methods relating to the device tempr,
# this is the join table between device and tempr
class DeviceTempr < ApplicationRecord
  #
  # Validations
  #
  validates :endpoint_type, presence: true
  validates :queue_response, presence: true
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

  def as_json(options = nil)
    ActiveModelSerializers::SerializableResource.new(self)
  end

  def template
    @template ||= begin
      options.tap do |h|
        h[:body] = tempr&.body
      end
    end
  end
end
