# frozen_string_literal: true

# Methods relating to the device tempr,
# this is the join table between device and tempr
class DeviceTempr < ApplicationRecord
  #
  # Relationships
  #
  belongs_to :device
  belongs_to :tempr

  #
  # Validations
  #
  validates :tempr_id, uniqueness: { scope: :device_id }

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
        request_method: options[:request_method] || options[:requestMethod],
        protocol: options[:protocol],
        headers: options[:headers],
        body: tempr&.body
      }
  end
end
