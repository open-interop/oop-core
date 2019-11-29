# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TemprTemplateValidator do
  let(:tempr) { FactoryBot.build(:tempr) }

  let(:template_validator) { described_class.new }

  describe '#missing_options?' do
    it do
      expect(template_validator.missing_options?(tempr.template)).to(
        eq(false)
      )
    end
  end

  describe '#valid_host_format?' do
    it do
      expect(template_validator.valid_host_format?(tempr.template)).to(
        eq(true)
      )
    end
  end

  describe '#valid_header_format?' do
    it do
      expect(template_validator.valid_header_format?(tempr.template)).to(
        eq(true)
      )
    end
  end

  describe '#valid_body_format?' do
    it do
      expect(template_validator.valid_body_format?(tempr.template)).to(
        eq(true)
      )
    end
  end
end
