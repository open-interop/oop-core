require 'rails_helper'

RSpec.describe Account, type: :model do
  describe '#interface_address' do
    context 'with a standard http port' do
      let(:account) { FactoryBot.create(:account) }

      it { expect(account.interface_address).to eq("http://test.host/") }
    end

    context 'with a non-standard port (int)' do
      let(:account) { FactoryBot.create(:account, interface_port: 8000) }

      it { expect(account.interface_address).to eq("http://test.host:8000/") }
    end

    context 'with a non-standard port (string)' do
      let(:account) { FactoryBot.create(:account, interface_port: '8000') }

      it { expect(account.interface_address).to eq("http://test.host:8000/") }
    end

    context 'with a non-standard path' do
      let(:account) { FactoryBot.create(:account, interface_path: '/oop') }

      it { expect(account.interface_address).to eq("http://test.host/oop") }
    end
  end
end
