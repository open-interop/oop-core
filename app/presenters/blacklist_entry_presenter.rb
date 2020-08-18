# frozen_string_literal: true

class BlacklistEntryPresenter < BasePresenter
  attributes :id, :ip_literal, :ip_range,
             :path_literal, :path_regex, :headers,
             :created_at, :updated_at

  def self.collection_for_microservices(records)
    records.map do |record|
      {
        id: record.id,
        ip_literal: record.ip_literal,
        ip_range: record.ip_range,
        path_literal: record.path_literal,
        path_regex: record.path_regex,
        headers: record.headers
      }
    end
  end
end
