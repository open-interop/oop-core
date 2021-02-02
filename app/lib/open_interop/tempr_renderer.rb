# frozen_string_literal: true

require 'open3'

module OpenInterop
  class TemprRenderer
    attr_reader :example_transmission, :template, :command, :response, :status, :err

    def initialize(example_transmission, template)
      @example_transmission = example_transmission
      @template = template
      @command = "node #{File.join(Rails.configuration.oop[:renderer_path], "bin/render")} -"
    end

    def render
      @err, @response, @status =
        Open3.capture3(@command, stdin_data: renderer_input)
    end

    def json_transmission
      @json_transmission ||= begin
        JSON.parse(example_transmission || '""')
      rescue JSON::ParserError => e
        Rails.logger.error e
        { 'error' => '[oop-core] Could not parse example transmission JSON.' }
      end
    end

    def json_response
      @json_response ||= begin
        JSON.parse(response || '""')
      rescue JSON::ParserError => e
        Rails.logger.error e
        { 'rendered' => {}, 'error' => '[oop-core] Could not parse response JSON.' }
      end
    end

    def renderer_input
      {
        message: {
          uuid: SecureRandom.uuid,
          path: '/dummy-path',
          body: json_transmission,
          query: '',
          method: 'post',
          ip: '127.0.0.1',
          headers: {},
          hostname: 'dummy-host.com',
          port: 80,
          protocol: 'http'
        },
        template: template || {},
        layers: []
      }.to_json
    end
  end
end
