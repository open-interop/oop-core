# frozen_string_literal: true

class TemprLayer < ApplicationRecord
  #
  # Relationships
  #

  belongs_to :tempr
  belongs_to :layer

  #
  # Validations
  #
  validates :tempr_id, uniqueness: { scope: :layer_id }
end
