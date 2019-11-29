# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'support@openinterop.org'
  layout 'mailer'
end
