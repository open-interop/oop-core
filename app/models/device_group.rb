# frozen_string_literal: true

# Methods relating to the device type
class DeviceGroup < ApplicationRecord
  #
  # Validations
  #
  validates :name, presence: true

  #
  # Relationships
  #
  belongs_to :account

  has_many :devices, dependent: :restrict_with_error
  has_many :temprs, dependent: :restrict_with_error

  #
  # Scopes
  #
  scope :by_name, -> { order('device_groups.name asc') }

  audited
end
