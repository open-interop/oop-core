# frozen_string_literal: true

class Account < ApplicationRecord
  #
  # Relationships
  #
  belongs_to :owner, class_name: 'User', optional: true

  has_many :users, dependent: :restrict_with_error
  has_many :device_groups, dependent: :restrict_with_error
  has_many :devices, dependent: :restrict_with_error
  has_many :sites, dependent: :restrict_with_error
  has_many :temprs, dependent: :restrict_with_error

  #
  # Scopes
  #
  scope :active, -> { where(active: true) }

  #
  # Validations
  #
  validates :hostname, uniqueness: true

  audited
end
