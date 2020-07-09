require 'rails_helper'

RSpec.describe Tempr, type: :model do
  let (:tempr) { FactoryBot.create(:tempr) }

  describe '#template' do
    context 'with a full template' do
      it { expect(tempr.valid?).to be(true) }
    end

    context 'with no template' do
      before { tempr.template = {} }
      xit { expect(tempr.valid?).to be(false) }
    end

    context 'with no host' do
      before { tempr.template[:host] = nil }
      xit { expect(tempr.valid?).to be(false) }
    end

    context 'with an invalid host (whitespace)' do
      before { tempr.template[:host] = ' example.com' }
      xit { expect(tempr.valid?).to be(false) }
    end

    context 'with an invalid host (trailing path)' do
      before { tempr.template[:host] = 'example.com/asdasd' }
      xit { expect(tempr.valid?).to be(false) }
    end

    context 'with an invalid host (includes protocol)' do
      before { tempr.template[:host] = 'http://example.com' }
      xit { expect(tempr.valid?).to be(false) }
    end

    context 'with a valid host (ipv4)' do
      before { tempr.template[:host] = '192.168.1.2' }
      xit { expect(tempr.valid?).to be(true) }
    end

    context 'with a valid host (ipv6)' do
      before { tempr.template[:host] = '2001:0db8:85a3:0000:0000:8a2e:0370:7334' }
      xit { expect(tempr.valid?).to be(true) }
    end

    context 'with no port' do
      before { tempr.template[:port] = nil }
      xit { expect(tempr.valid?).to be(false) }
    end

    context 'with no path' do
      before { tempr.template[:path] = nil }
      xit { expect(tempr.valid?).to be(false) }
    end

    context 'with no request_method' do
      before { tempr.template[:request_method] = nil }
      xit { expect(tempr.valid?).to be(false) }
    end

    context 'with no protocol' do
      before { tempr.template[:protocol] = nil }
      xit { expect(tempr.valid?).to be(false) }
    end

    context 'with headers as an array' do
      before { tempr.template[:headers] = [] }
      xit { expect(tempr.valid?).to be(false) }
    end

    context 'with empty headers' do
      before { tempr.template[:headers] = nil }
      xit { expect(tempr.valid?).to be(true) }
    end

    context 'with body as an array' do
      before { tempr.template[:body] = [] }
      xit { expect(tempr.valid?).to be(false) }
    end

    context 'with body as a string' do
      before { tempr.template[:body] = 'asdasdasd' }
      xit { expect(tempr.valid?).to be(false) }
    end

    context 'with empty body' do
      before { tempr.template[:body] = nil }
      xit { expect(tempr.valid?).to be(true) }
    end
  end
end
