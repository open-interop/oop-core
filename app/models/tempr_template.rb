# frozen_string_literal: true

class TemprTemplate < ApplicationRecord
  #
  # Validations
  #
  validates :temprs, presence: true

  #
  # Relationships
  #
  has_one :tempr, as: :templateable

  #
  # Serializations
  #
  serialize :temprs, Hash

  def render
    {
      temprs: temprs
    }
  end
end

# == Schema Information
#
# Table name: tempr_templates
#
#  id         :bigint           not null, primary key
#  temprs     :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
