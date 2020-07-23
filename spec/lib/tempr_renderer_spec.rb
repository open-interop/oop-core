require 'rails_helper'

RSpec.describe OpenInterop::TemprRenderer do
  describe '#preview' do
    describe '#json_response' do
      let(:renderer) do
        described_class.new(nil, nil)
      end

      it do
        expect(renderer.json_response).to(
          eq('')
        )
      end
    end

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

    context 'with a mustache object' do
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
            host: {
              language: 'text',
              script: 'example.com'
            },
            port: {
              language: 'text',
              script: '80'
            },
            path: {
              language: 'text',
              script: '/test/{{message.body.key1}}/{{message.body.key2}}'
            },
            request_method: {
              language: 'text',
              script: 'POST'
            },
            protocol: {
              language: 'text',
              script: 'http',
            },
            headers: {
              language: 'js',
              script: 'module.exports = { "Content-Type" : "application/json" }'
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

    context 'with a malformed js object in the response' do
      let(:tempr) do
        javascript_template =
          {
            host: {
              language: 'text',
              script: 'example.com'
            },
            port: {
              language: 'text',
              script: '80'
            },
            path: {
              language: 'text',
              script: '/test/{{message.body.key1}}/{{message.body.key2}}'
            },
            request_method: {
              language: 'text',
              script: 'POST'
            },
            protocol: {
              language: 'text',
              script: 'http'
            },
            headers: {
              language: 'js',
              script: 'module.exports = { "Content-Type" : "application/json" }'
            },
            body: {
              language: 'js',
              script:
                'module.exports ==badsyntax= {
                    "firstKey" : message.message.body.key1,
                    "secondKey" : message.message.body.key2
                  };'
            }
          }.with_indifferent_access

        FactoryBot.create(:tempr, template: javascript_template)
      end

      before do
        allow_any_instance_of(described_class).to(
          receive(:response).and_return('module.exports ==badsyntax= {
            "firstKey" : message.message.body.key1,
            "secondKey" : message.message.body.key2
          };')
        )
      end

      let(:renderer) do
        described_class.new(tempr.example_transmission, tempr.template)
      end

      before { renderer.render }

      it do
        expect(renderer.json_response['rendered']).to(
          eq({})
        )
      end

      it do
        expect(renderer.json_response['error']).to(
          eq('[oop-core] Could not parse response JSON.')
        )
      end
    end

    context 'with a malformed js object in the request' do
      let(:tempr) do
        javascript_template =
          {
            host: {
              language: 'text',
              script: 'example.com'
            },
            port: {
              language: 'text',
              script: '80'
            },
            path: {
              language: 'text',
              script: '/test/{{message.body.key1}}/{{message.body.key2}}'
            },
            request_method: {
              language: 'text',
              script: 'POST'
            },
            protocol: {
              language: 'text',
              script: 'http'
            },
            headers: {
              language: 'js',
              script: 'module.exports = { "Content-Type" : "application/json" }'
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
          receive(:example_transmission).and_return('==badsyntax==')
        )
      end

      let(:renderer) do
        described_class.new(tempr.example_transmission, tempr.template)
      end

      before { renderer.render }

      it do
        expect(renderer.json_response['rendered']).to(
          eq({})
        )
      end

      it do
        expect(renderer.json_response['error']).to(
          eq('[oop-core] Could not parse response JSON.')
        )
      end
    end
  end
end
