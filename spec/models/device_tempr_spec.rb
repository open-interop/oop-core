require 'rails_helper'

RSpec.describe DeviceTempr, type: :model do
  before do
    allow_any_instance_of(Device).to(
      receive(:bunny_connection).and_return(BunnyMock.new.start)
    )
  end

  let(:device_tempr) { FactoryBot.create(:device_tempr) }

  describe '#template' do
    it { expect(device_tempr.template.keys).to include(:host, :port, :path, :requestMethod, :protocol, :headers, :body)}
  end
end
