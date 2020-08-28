require 'rails_helper'

RSpec.describe Transmission, type: :model do
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
