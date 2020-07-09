# frozen_string_literal: true

class Tempr < ApplicationRecord
  #
  # Constants
  #
  ENDPOINT_TYPES = %w[http tempr].freeze

  #
  # Validations
  #
  validates :name, presence: true
  validates :endpoint_type, presence: true, inclusion: { in: ENDPOINT_TYPES }

  validates_with AccountValidator, fields: %i[device_group]

  #
  # Relationships
  #
  belongs_to :account
  belongs_to :device_group
  belongs_to :tempr, optional: true

  has_many :device_temprs
  has_many :devices, through: :device_temprs

  has_many :schedule_temprs
  has_many :schedules, through: :schedule_temprs

  has_many :temprs

  has_many :tempr_layers
  has_many :layers, through: :tempr_layers

  belongs_to :templateable, polymorphic: true, optional: true

  #
  # Serializations
  #
  serialize :body, Hash # Method now deprecated
  serialize :template, Hash # Method now deprecated

  def template
    templateable.render
  end

  def template=(h)
    return if endpoint_type.blank?

    self.templateable =
      case endpoint_type
      when 'http'
        HttpTemplate.new(h)
      when 'tempr'
        TemprTemplate.new(h)
      end
  end

  audited
end
