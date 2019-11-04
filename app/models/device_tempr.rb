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
