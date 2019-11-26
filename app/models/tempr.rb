# frozen_string_literal: true

class Tempr < ApplicationRecord
  #
  # Validations
  #
  validates :name, presence: true
  validates :endpoint_type, presence: true
  validates_with TemprTemplateValidator
  validates_with AccountValidator, fields: %i[device_group]

  #
  # Relationships
  #
  belongs_to :account
  belongs_to :device_group
  belongs_to :tempr, optional: true

  has_many :device_temprs
  has_many :devices, through: :device_temprs

  has_many :temprs

  #
  # Serializations
  #
  serialize :body, Hash
  serialize :template, Hash

  audited
end
