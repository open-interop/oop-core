# frozen_string_literal: true

class LayerPresenter < BasePresenter
  attributes :id, :name, :reference, :script,
             :created_at, :updated_at, :archived

  def self.record_for_microservices(records)
    records.map do |record|
      {
        id: record.id,
        reference: record.reference,
        script: record.script
      }
    end
  end
end
