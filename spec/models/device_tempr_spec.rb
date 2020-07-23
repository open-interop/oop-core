# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DeviceTempr, type: :model do
  let(:device_tempr) { FactoryBot.create(:device_tempr) }

  describe '#template' do
    it do
      expect(device_tempr.template.keys).to(
        include(
          :host, :port, :path, :request_method,
          :protocol, :headers, :body
        )
      )
    end
  end
end
