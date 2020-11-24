require 'rails_helper'

RSpec.describe DevicePresenter do
  describe '::collection_for_microservices' do
    context 'Device' do
      let!(:device_tempr) { FactoryBot.create(:device_tempr) }
      let(:device) { device_tempr.device }
      let(:tempr) { device_tempr.tempr }

      let(:collection) do
        described_class.collection_for_microservices(
          [device]
        )
      end

      context '#collection_for_microservices' do
        it do
          expect(collection.first).to(
            eq(
              id: device.id,
              authentication: device.authentication,
              temprUrl: device.tempr_url
            )
          )
        end
      end
    end
  end
end
