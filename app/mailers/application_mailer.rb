# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: Rails.configuration.oop[:from_email]
  layout 'mailer'
end
