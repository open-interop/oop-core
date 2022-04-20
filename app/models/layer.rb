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

  has_many :tempr_layers, dependent: :restrict_with_error
  has_many :temprs, through: :tempr_layers

  # Scopes
  scope :archived, -> { where(archived: true) }

  audited associated_with: :account
end

# == Schema Information
#
# Table name: layers
#
#  id         :bigint           not null, primary key
#  archived   :boolean          default(FALSE)
#  name       :string
#  reference  :string
#  script     :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :integer
#
