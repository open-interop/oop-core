require 'rails_helper'

RSpec.describe Tempr, type: :model do
  let!(:tempr) { FactoryBot.create(:tempr) }
  let!(:http_template) { tempr.templateable }

  describe '#template' do
    context 'with an http template' do
      it { expect(tempr.valid?).to be(true) }
    end

    context 'update the host' do
      let(:template) { tempr.template }

      before do
        template[:host] = {
          language: 'text',
          script: 'newhost.host'
        }

        tempr.update_attribute(:template, template)

        tempr.reload
      end

      it do
        expect(tempr.templateable.host).to(
          eq(
            language: 'text',
            script: 'newhost.host'
          )
        )
      end

      it { expect(http_template.id).to eq(tempr.templateable_id) }
    end

    context 'with no template' do
      before do
        tempr.endpoint_type = 'tempr'
        tempr.save
        tempr.reload
      end

      it { expect(tempr.endpoint_type).to eq('http') }
    end
  end

  describe '#template' do
    context 'with a tempr template' do
      let!(:tempr) do
        FactoryBot.create(
          :tempr,
          endpoint_type: 'tempr',
          template: {
            temprs: {
              language: 'js',
              script:
                'const http = require("http");
                const ret = [];
                for (const res of message.body) {
                    ret.push(http(
                        "POST",
                        "https",
                        "test.co.uk",
                        "/post/path"
                        { id: result.id, value: result.val }
                    ));
                }
                module.exports = ret;'
            }
          }
        )
      end

      let!(:tempr_template) { tempr.templateable }

      it { expect(tempr_template.temprs[:language]).to eq('js') }
    end

    context 'with no template' do
      before do
        tempr.endpoint_type = 'tempr'
        tempr.save
        tempr.reload
      end

      it { expect(tempr.endpoint_type).to eq('http') }
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
