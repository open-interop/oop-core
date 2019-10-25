# frozen_string_literal: true

# Methods relating to the device tempr,
# this is the join table between device and tempr
class DeviceTempr < ApplicationRecord
  #
  # Validations
  #
  validates :name, presence: true
  validates :endpoint_type, presence: true
  validates :queue_response, inclusion: { in: [true, false] }
  validates :options, presence: true
  validates_with DeviceTemprOptionsValidator

  #
  # Relationships
  #
  belongs_to :device
  belongs_to :tempr

  #
  # Serializations
  #
  serialize :options, Hash

  def template
    @template ||=
      {
        host: options[:host],
        port: options[:port],
        path: options[:path],
        requestMethod: options[:request_method] || options[:requestMethod],
        protocol: options[:protocol],
        headers: options[:headers],
        body: tempr&.body
      }
  end
end
