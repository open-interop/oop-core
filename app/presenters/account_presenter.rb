# frozen_string_literal: true

class AccountPresenter < BasePresenter
  attributes :id, :name, :active, :owner_id, 
                 :created_at, :updated_at, :interface_scheme, 
                     :interface_port, :interface_path

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

