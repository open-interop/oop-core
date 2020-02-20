# frozen_string_literal: true

class Transmission < ApplicationRecord
  #
  # Relationships
  #
  belongs_to :device, optional: true
  belongs_to :tempr, optional: true
  belongs_to :schedule, optional: true
end
