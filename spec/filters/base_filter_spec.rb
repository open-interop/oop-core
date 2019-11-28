# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BaseFilter do
  let(:filter) { described_class.new({}) }

  describe '#base_scope' do
    it do
      expect do
        filter.base_scope
      end.to raise_error(OpenInterop::Errors::NotImplemented)
    end
  end

  describe '#table_name' do
    it do
      expect do
        filter.table_name
      end.to raise_error(OpenInterop::Errors::NotImplemented)
    end
  end
end
