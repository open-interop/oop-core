require 'rails_helper'

RSpec.describe OpenInterop::TemprRenderer do
  describe '#preview' do
    context 'with no template' do
      let(:tempr) { FactoryBot.create(:tempr) }

      before do
        allow_any_instance_of(described_class).to(
          receive(:json_response).and_return(
            'rendered' => {},
            'console' => ''
          )
        )
      end

      let(:renderer) do
        described_class.new(nil, nil)
      end

      before { renderer.render }

      it do
        expect(renderer.json_response).to(
          eq({'console' => '', 'rendered' => {}})
        )
      end

      it do
        expect(renderer.json_response).to(
          eq({'console' => '', 'rendered' => {}})
        )
      end
    end

    context 'with a moustache object' do
      let(:tempr) { FactoryBot.create(:tempr) }

      before do
        allow_any_instance_of(described_class).to(
          receive(:json_response).and_return(
            'rendered' => {
              'host' => 'example.com',
              'port' => '80',
              'path' => '/test/some-value/some-other-value',
              'request_method' => 'POST',
              'protocol' => 'http',
              'headers' => {
                'Content-Type' => 'application/json'
              },
              'body' => {
                'body' => 'asd of this thing some-value and also some-other-value'
              }
            },
            'console' => ''
          )
        )
      end

      let(:renderer) do
        described_class.new(tempr.example_transmission, tempr.template)
      end

      before { renderer.render }

      it { expect(renderer.empty_response?).to eq(false) }

      it { expect(renderer.advanced_response?).to eq(false) }

      it do
        expect(renderer.json_response['rendered']['path']).to(
          eq('/test/some-value/some-other-value')
        )
      end

      it do
        expect(renderer.json_response['rendered']['body']['body']).to(
          eq('asd of this thing some-value and also some-other-value')
        )
      end
    end

    context 'with a js object' do
      let(:tempr) do
        javascript_template =
          {
            host: 'example.com',
            port: 80,
            path: '/test/{{message.body.key1}}/{{message.body.key2}}',
            request_method: 'POST',
            protocol: 'http',
            headers: {
              'Content-Type': 'application/json'
            },
            body: {
              language: 'js',
              script:
                'module.exports = {
                    "firstKey" : message.message.body.key1,
                    "secondKey" : message.message.body.key2
                  };'
            }
          }.with_indifferent_access

        FactoryBot.create(:tempr, template: javascript_template)
      end

      before do
        allow_any_instance_of(described_class).to(
          receive(:json_response).and_return(
            'rendered' => {
              'host' => 'example.com',
              'port' => '80',
              'path' => '/test/some-value/some-other-value',
              'request_method' => 'POST',
              'protocol' => 'http',
              'headers' => {
                'Content-Type' => 'application/json'
              },
              'body' => "{\"firstKey\":\"some-value\",\"secondKey\":\"some-other-value\"}"
            },
            'console' => ''
          )
        )
      end

      let(:renderer) do
        described_class.new(tempr.example_transmission, tempr.template)
      end

      before { renderer.render }

      let(:json_body) { JSON.parse(renderer.json_response['rendered']['body']) }

      it { expect(renderer.empty_response?).to eq(false) }

      it { expect(renderer.advanced_response?).to eq(true) }

      it do
        expect(renderer.json_response['rendered']['path']).to(
          eq('/test/some-value/some-other-value')
        )
      end

      it do
        expect(json_body['firstKey']).to(
          eq('some-value')
        )
      end
    end
  end
end
