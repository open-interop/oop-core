# frozen_string_literal: true

FactoryBot.define do
  factory :http_template do
    host { { language: 'text', script: 'example.com' } }
    port { { language: 'text', script: '80' } }
    path do
      {
        language: 'text',
        script: '/test/{{message.body.key1}}/{{message.body.key2}}'
      }
    end
    request_method { { language: 'text', script: 'POST' } }
    protocol { { language: 'text', script: 'http' } }
    headers do
      {
        language: 'json',
        script: '{ "Content-Type" : "application/json" }'
      }
    end
    body do
      {
        language: 'mustache',
        body:
          "asd of this thing {{message.body.key1}} and also {{message.body.key2}}"
      }
    end
  end
end
