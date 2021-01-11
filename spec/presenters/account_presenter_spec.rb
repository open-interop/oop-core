require 'rails_helper'

RSpec.describe AccountPresenter do
  describe '::collection_for_microservices' do
    context 'Account' do
      let(:account) { FactoryBot.create(:account) }

      let(:collection) do
        described_class.collection_for_microservices(
          [account]
        )
      end

      context '#collection_for_microservices' do
        it do
          expect(collection.first).to(
            eq(
              id: account.id,
              hostname: account.hostname,
            )
          )
        end
      end
    end
  end
end

