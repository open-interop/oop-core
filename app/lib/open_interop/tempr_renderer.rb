# frozen_string_literal: true

require 'open3'

module OpenInterop
  class TemprRenderer
    attr_reader :example_transmission, :template, :command, :response, :status, :err

    def initialize(example_transmission, template)
      @example_transmission = example_transmission
      @template = template
      @command = "node #{Rails.root.join('scripts', 'tempr-renderer.js')}"
    end

    def render
      @response, @err, @status =
        Open3.capture3(@command, stdin_data: renderer_input)
    end

    def empty_response?
      return true if json_response['rendered'].blank?
      return true if json_response['rendered']['body'].blank?

      false
    end

    def advanced_response?
      return false if empty_response?
      return true if template['body'].present? && template['body']['script'].present?

      false
    end

    def json_transmission
      @json_transmission ||= begin
        JSON.parse(example_transmission || '""')
      rescue JSON::ParserError => e
        Rails.logger.error e
        {}
      end
    end

    def json_response
      @json_response ||= begin
        JSON.parse(response || '""')
      rescue JSON::ParserError => e
        Rails.logger.error e
        { 'rendered' => {} }
      end
    end

    def renderer_input
      {
        template: {
          message: {
            path: '/dummy-path',
            body: json_transmission
          },
          uuid: SecureRandom.uuid,
          tempr: {
            template: template || {}
          },
          device: {}
        },
        renderer: ENV['OOP_RENDERER_PATH']
      }.to_json
    end
  end
end
