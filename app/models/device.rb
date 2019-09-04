# frozen_string_literal: true

# Methods relating to the device
class Device < ApplicationRecord
  #
  # Validations
  #
  validates :name, presence: true
  validates_with DeviceAuthenticationValidator

  #
  # Relationships
  #
  belongs_to :account
  belongs_to :device_group
  belongs_to :site

  has_many :device_temprs
  has_many :transmissions

  #
  # Serialisations
  #
  serialize :authentication_headers, Array
  serialize :authentication_query, Array

  #
  # Scopes
  #
  scope :active, -> { where(active: true) }

  def authentication
    @authentication ||= {
      hostname: account.hostname
    }.tap do |h|
      authentication_headers.each do |header|
        h["headers.#{header[0].downcase}"] = header[1]
      end

      authentication_query.each do |query|
        h["query.#{query[0].downcase}"] = query[1]
      end

      authentication_path.present? &&
        h['path'] = authentication_path
    end
  end

  def assign_tempr(tempr, params)
    device_temprs.create(
      device: self,
      tempr: tempr,
      endpoint_type: params[:endpoint_type],
      queue_response: params[:queue_response],
      options: params[:options].to_h
    )
  end
end
