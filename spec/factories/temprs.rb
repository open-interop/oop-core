# frozen_string_literal: true

FactoryBot.define do
  factory :tempr do
    account { Account.first || create(:account) }
    device_group
    name { 'Some tempr' }
    endpoint_type { 'http' }
    queue_request { false }
    queue_response { false }
    example_transmission do
      '{ "key1" : "some-value", "key2": "some-other-value" }'
    end
    template do
      {
        host: { language: 'text', script: 'example.com' } ,
        port: { language: 'text', script: '80' },
        path: { language: 'text', script: '/test/{{message.body.key1}}/{{message.body.key2}}' },
        request_method: { language: 'text', script: 'POST' },
        protocol: { language: 'text', script: 'http' },
        headers: {
          language: 'js',
          script: 'module.exports = { "Content-Type" : "application/json" }'
        },
        body: {
          language: 'mustache',
          body:
            'asd of this thing {{message.body.key1}} and also {{message.body.key2}}'
        }
      }
    end
  end
end

# == Schema Information
#
# Table name: temprs
#
#  id                   :bigint           not null, primary key
#  body                 :text
#  description          :text
#  endpoint_type        :string
#  example_transmission :text
#  name                 :string
#  notes                :text
#  queue_request        :boolean          default(FALSE)
#  queue_response       :boolean          default(FALSE)
#  template             :text
#  templateable_type    :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  account_id           :integer
#  device_group_id      :integer
#  templateable_id      :bigint
#  tempr_id             :integer
#
# Indexes
#
#  index_temprs_on_templateable_type_and_templateable_id  (templateable_type,templateable_id)
#
