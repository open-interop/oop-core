# frozen_string_literal: true

class BlacklistEntry < ApplicationRecord
  #
  # Validations
  #
  validates_with BlacklistEntryValidator

  #
  # Relationships
  #
  belongs_to :account

  # Scopes
  scope :archived, -> { where(archived: true) }

  audited
end

