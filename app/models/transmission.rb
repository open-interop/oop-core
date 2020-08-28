# frozen_string_literal: true

class Transmission < ApplicationRecord
  #
  # Relationships
  #
  belongs_to :account
  belongs_to :device, optional: true
  belongs_to :tempr, optional: true
  belongs_to :schedule, optional: true
end

# == Schema Information
#
# Table name: transmissions
#
#  id                :bigint           not null, primary key
#  message_uuid      :string
#  request_body      :text
#  response_body     :text
#  status            :integer
#  success           :boolean
#  transmission_uuid :string
#  transmitted_at    :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  account_id        :integer
#  device_id         :integer
#  schedule_id       :integer
#  tempr_id          :integer
#
