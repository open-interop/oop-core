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

  #
  # Callbacks
  #
  after_save do
    Rails.cache.delete([device, 'services/temprs'])
  end

  after_destroy do
    Rails.cache.delete([device, 'services/temprs'])
  end

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

# == Schema Information
#
# Table name: device_temprs
#
#  id             :bigint           not null, primary key
#  endpoint_type  :string
#  name           :string
#  options        :text
#  queue_response :boolean
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  device_id      :integer
#  tempr_id       :integer
#
