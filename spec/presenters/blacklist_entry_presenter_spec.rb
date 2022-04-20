require 'rails_helper'

RSpec.describe BlacklistEntryPresenter do
  describe '::collection_for_microservices' do
    context 'BlacklistEntry' do
      let(:blacklist_entry) { FactoryBot.create(:blacklist_entry) }

      let(:collection) do
        described_class.collection_for_microservices(
          [blacklist_entry]
        )
      end

      context '#collection_for_microservices' do
        it do
          expect(collection.first).to(
            eq(
              id: blacklist_entry.id,
              ip_literal: blacklist_entry.ip_literal,
              ip_range: blacklist_entry.ip_range,
              path_literal: blacklist_entry.path_literal,
              path_regex: blacklist_entry.path_regex,
              headers: blacklist_entry.headers
            )
          )
        end
      end
    end
  end
end
