# frozen_string_literal: true

# Methods relating to the device
class Site < ApplicationRecord
  #
  # Validations
  #
  validates :name, presence: true

  #
  # Relationships
  #
  belongs_to :account
  belongs_to :site, optional: true

  #
  # Serializers
  #
  serialize :external_uuids, Hash
end
