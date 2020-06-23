# frozen_string_literal: true

class Layer < ApplicationRecord
  #
  # Validations
  #
  validates :name, presence: true
  validates :reference, presence: true, uniqueness: { scope: :account_id }, format: { with: /\A[a-zA-Z0-9\-\_]+\z/ }

  #
  # Relationships
  #
  belongs_to :account

  has_many :tempr_layers
  has_many :temprs, through: :tempr_layers

  # Scopes
  scope :archived, -> { where(archived: true) }

  audited
end
