# frozen_string_literal: true

class Account < ApplicationRecord
  #
  # Relationships
  #
  belongs_to :owner, class_name: 'User', optional: true

  has_many :users
  has_many :device_groups
  has_many :devices
  has_many :sites

  #
  # Scopes
  #
  scope :active, -> { where(active: true) }

  #
  # Validations
  #
  validates :hostname, uniqueness: true
end
