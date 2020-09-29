# frozen_string_literal: true

# Methods relating to the device
class Device < ApplicationRecord
  #
  # Validations
  #
  validates :name, presence: true
  validates_with DeviceAuthenticationValidator
  validates :authentication_path, uniqueness:
    { scope: :account_id, allow_nil: true }
  validates_with AccountValidator, fields: %i[site device_group]

  #
  # Callbacks
  #
  before_destroy :remove_associated_transmissions
  after_create :queue_from_create
  after_update :queue_from_update, if: :authentication_details_changed?
  after_destroy :queue_from_destroy
  after_save do
    Rails.cache.delete([id, 'services/devices'])
  end

  #
  # Relationships
  #
  belongs_to :account
  belongs_to :device_group
  belongs_to :site

  has_many :device_temprs
  has_many :temprs, through: :device_temprs
  has_many :transmissions, dependent: :restrict_with_error
  has_many :messages, as: :origin

  #
  # Serialisations
  #
  serialize :authentication_headers, Array
  serialize :authentication_query, Array

  #
  # Scopes
  #
  scope :active, -> { where(active: true) }
  scope :by_name, -> { order('devices.name asc') }

  #
  # Get/Setters
  #
  attr_writer :force_delete

  audited

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

  def update_queue
    UpdateQueue.new(
      :device,
      Rails.configuration.oop[:rabbit][:devices_exchange]
    )
  end

  def queue_from_create
    update_queue.publish(
      'add',
      id: id,
      authentication: authentication
    )
  end

  def queue_from_update
    @authentication = nil

    update_queue.publish(
      'update',
      id: id,
      authentication: authentication
    )
  end

  def queue_from_destroy
    update_queue.publish(
      'delete',
      id: id
    )
  end

  def tempr_url
    [].tap do |a|
      a << Rails.configuration.oop[:scheme]
      a << account.hostname

      if Rails.configuration.oop[:port].present? &&
         ![80, 443].include?(Rails.configuration.oop[:port].to_i)
        a << ':'
        a << Rails.configuration.oop[:port]
      end

      a << Rails.configuration.oop[:path] || '/'
      a << "services/v1/devices/#{id}/temprs"
    end.join
  end

  def remove_associated_transmissions
    @force_delete == true &&
      transmissions.delete_all
  end
end

# == Schema Information
#
# Table name: devices
#
#  id                     :bigint           not null, primary key
#  active                 :boolean          default(TRUE)
#  authentication_headers :text
#  authentication_path    :string
#  authentication_query   :text
#  latitude               :decimal(10, 6)
#  longitude              :decimal(10, 6)
#  name                   :string
#  queue_messages         :boolean          default(FALSE)
#  time_zone              :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  account_id             :integer
#  device_group_id        :integer
#  site_id                :integer
#
