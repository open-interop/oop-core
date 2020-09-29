# frozen_string_literal: true

module OpenInterop
  module Errors
    class AccessDenied < StandardError; end
    class AccountNotFound < StandardError; end
    class NotImplemented < StandardError; end
    class OriginNotFound < StandardError; end
  end
end
