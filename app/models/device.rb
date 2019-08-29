# frozen_string_literal: true

# Methods relating to the device
class Device < ApplicationRecord
  #
  # Validations
  #
  validates :name, presence: true
  validates :authentication, presence: true

  #
  # Relationships
  #
  belongs_to :account
  belongs_to :device_group
  belongs_to :site

  has_many :device_temprs

  #
  # Serialisations
  #
  serialize :authentication_headers, Array
  serialize :authentication_query, Array

  #
  # Scopes
  #
  scope :active, -> { where(active: true) }

  def hostname
    @hostname ||=
      account.hostname
  end

  def authentication
    @authentication = {}

    authentication_headers.each do |header|
      @authentication["header.#{header[0]}"] = header[1]
    end

    authentication_query.each do |query|
      @authentication["query.#{query[0]}"] = query[1]
    end

    if authentication_path.present?
      @authentication['path'] = authentication_path
    end

    @authentication
  end

  def assign_tempr(tempr, params)
    device_temprs.create(
      device: self,
      tempr: tempr,
      endpoint_type: params[:endpoint_type],
      queue_response: params[:queue_response],
      template: params[:template].to_h
    )
  end
end
