# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TransmissionQueue do
  let(:device) { FactoryBot.create(:device) }
  let(:tempr) { FactoryBot.create(:tempr, queue_request: true, queue_response: true ) }
  let(:device_tempr) { FactoryBot.create(:device_tempr, device: device, tempr: tempr) }
end
