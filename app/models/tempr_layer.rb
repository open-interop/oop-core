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

# == Schema Information
#
# Table name: tempr_layers
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  layer_id   :integer
#  tempr_id   :integer
#
