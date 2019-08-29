# frozen_string_literal: true

# Methods relating to the device tempr,
# this is the join table between device and tempr
class DeviceTempr < ApplicationRecord
  #
  # Validations
  #
  validates :endpoint_type, presence: true
  validates :queue_response, presence: true
  validates :template, presence: true

  #
  # Relationships
  #
  belongs_to :device
  belongs_to :tempr

  #
  # Serializations
  #
  serialize :template, Hash

  def as_json
    ActiveModelSerializers::SerializableResource.new(self)
  end
end
