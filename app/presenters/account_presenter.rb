# frozen_string_literal: true

class AccountPresenter < BasePresenter
  def self.record_for_microservices(record)
    {
        id: record.id,
        hostname: record.hostname,
    }
  end

  def self.collection_for_microservices(records)
    records.map do |record|
        record_for_microservices(record)
    end
  end
end

