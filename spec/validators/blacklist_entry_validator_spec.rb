# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AccountValidator do
  describe '#validate' do
    context 'with all empty fields' do
      let(:blacklist_entry) { FactoryBot.build(:blacklist_entry, ip_literal: "", ip_range: "", path_literal: "", path_regex: "", headers: "") }
      it { expect(blacklist_entry).to be_invalid }
    end

    context 'with one non empty field' do
        let(:blacklist_entry) { FactoryBot.build(:blacklist_entry, ip_literal: "127.0.0.1", ip_range: "", path_literal: "", path_regex: "", headers: "") }
      it { expect(blacklist_entry).to be_valid }
    end
  end
end
