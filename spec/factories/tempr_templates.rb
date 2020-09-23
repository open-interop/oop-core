# frozen_string_literal: true

FactoryBot.define do
  factory :tempr_template do
    temprs do
      {
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
    end
  end
end

# == Schema Information
#
# Table name: tempr_templates
#
#  id         :bigint           not null, primary key
#  temprs     :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
