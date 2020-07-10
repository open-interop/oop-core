# frozen_string_literal: true

class HttpTemplate < ApplicationRecord
  #
  # Validations
  #
  validates :host, presence: true
  validates :port, presence: true
  validates :path, presence: true
  validates :protocol, presence: true
  validates :request_method, presence: true

  #
  # Relationships
  #
  has_one :tempr, as: :templateable

  #
  # Serializations
  #
  serialize :host, Hash
  serialize :port, Hash
  serialize :path, Hash
  serialize :protocol, Hash
  serialize :request_method, Hash
  serialize :headers, Hash
  serialize :body, Hash

  def requestMethod=(request_method_hash)
    self.request_method = request_method_hash
  end

  def render
    {
      host: host,
      port: port,
      path: path,
      protocol: protocol,
      requestMethod: request_method,
      headers: headers,
      body: body
    }
  end
end
