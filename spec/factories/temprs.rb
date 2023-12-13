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
    templateable { HttpTemplate.first || create(:http_template) }

    factory :tempr_tempr do
      templateable { TemprTemplate.first || create(:tempr_template) }
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
#  save_console         :boolean          default(FALSE)
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
#  index_temprs_on_account_id                             (account_id)
#  index_temprs_on_created_at                             (created_at)
#  index_temprs_on_device_group_id                        (device_group_id)
#  index_temprs_on_templateable_type_and_templateable_id  (templateable_type,templateable_id)
#  index_temprs_on_tempr_id                               (tempr_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (device_group_id => device_groups.id)
#  fk_rails_...  (tempr_id => temprs.id)
#
