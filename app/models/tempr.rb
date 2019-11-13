# frozen_string_literal: true

class Tempr < ApplicationRecord
  #
  # Validations
  #
  validates :name, presence: true
  validates_with TemprTemplateValidator

  #
  # Relationships
  #
  belongs_to :account
  belongs_to :device_group

  has_many :device_temprs
  has_many :devices, through: :device_temprs

  #
  # Serializations
  #
  serialize :body, Hash
  serialize :template, Hash

  audited
end
