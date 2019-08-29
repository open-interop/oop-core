# frozen_string_literal: true

# Methods relating to the device type
class DeviceGroup < ApplicationRecord
  #
  # Validations
  #
  validates :name, presence: true
  validates :account_id, presence: true

  #
  # Relationships
  #
  belongs_to :account

  has_many :devices
  has_many :temprs
end
