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

  validates :templateable, presence: true
  validates_associated :templateable

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
  serialize :body, Hash # DB field now deprecated
  serialize :template, Hash # DB field now deprecated

  #
  # Attributes
  #
  attr_readonly :endpoint_type

  def template
    templateable&.render
  end

  def template=(template_hash)
    return if endpoint_type.blank?

    if templateable.blank?
      create_templateable(template_hash)
    else
      templateable.update(template_hash)
    end
  end

  def create_templateable(template_hash)
    self.templateable =
      case endpoint_type
      when 'http'
        HttpTemplate.new(template_hash)
      when 'tempr'
        TemprTemplate.new(template_hash)
      end
  end

  audited
end

# == Schema Information
#
# Table name: temprs
#
#  id                   :bigint           not null, primary key
#  body                 :text
#  description          :text
#  endpoint_type        :string
#  example_transmission :text
#  name                 :string
#  notes                :text
#  queue_request        :boolean          default(FALSE)
#  queue_response       :boolean          default(FALSE)
#  template             :text
#  templateable_type    :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  account_id           :integer
#  device_group_id      :integer
#  templateable_id      :bigint
#  tempr_id             :integer
#
# Indexes
#
#  index_temprs_on_templateable_type_and_templateable_id  (templateable_type,templateable_id)
#
