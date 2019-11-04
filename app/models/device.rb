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
  has_many :temprs, through: :device_temprs
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

  #
  # Callbacks
  #
  after_create :queue_from_create
  after_update :queue_from_update, if: :authentication_details_changed?
  after_destroy :queue_from_destroy

  def authentication
    @authentication ||= {
      'hostname' => account.hostname
    }.tap do |h|
      authentication_headers.each do |header|
        h["headers.#{header[0].downcase}"] = header[1]
      end

      authentication_query.each do |query|
        h["query.#{query[0]}"] = query[1]
      end

      authentication_path.present? &&
        h['path'] = authentication_path
    end
  end

  def authentication_details_changed?
    saved_change_to_authentication_headers? ||
      saved_change_to_authentication_query? ||
      saved_change_to_authentication_path?
  end

  def queue_from_create
    bunny_exchange.publish(
      {
        action: 'add',
        device: {
          id: id,
          authentication: authentication
        }
      }.to_json
    )

    bunny_connection_close
  end

  def queue_from_update
    @authentication = nil

    bunny_exchange.publish(
      {
        action: 'update',
        device: {
          id: id,
          authentication: authentication
        }
      }.to_json
    )

    bunny_connection_close
  end

  def queue_from_destroy
    bunny_exchange.publish(
      {
        action: 'delete',
        device: {
          id: id
        }
      }.to_json
    )

    bunny_connection_close
  end

  def bunny_connection
    @bunny_connection ||=
      Bunny.new.start
  end

  def bunny_exchange
    @bunny_exchange ||= begin
      bunny_connection.create_channel
                      .fanout(
                        ENV['OOP_CORE_DEVICE_UPDATE_EXCHANGE'],
                        auto_delete: false,
                        durable: true
                      )
    end
  end

  def bunny_connection_close
    bunny_connection.close
    @bunny_connection = nil
    @bunny_exchange = nil
  end
end
