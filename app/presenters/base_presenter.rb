# frozen_string_literal: true

class BasePresenter
  def initialize(records, page_params = {})
    @records = records
    @page_params = page_params
  end

  def self.fields
    @fields
  end

  def self.attributes(*fields)
    @fields = fields
  end

  def all_records?
    @page_params[:size].to_i == -1 && @records.count.positive?
  end

  def page_size
    return @page_params[:size] unless all_records?

    @records.count
  end

  def collection_for_json
    @records =
      @records.page(@page_params[:number] || 1)
              .per(page_size)

    {
      total_records: @records.total_count,
      number_of_pages: @records.total_pages,
      page: { number: @records.current_page, size: @records.limit_value },
      data: @page_params[:count] ? nil : data,
      core_version: Rails.application.config.version_name
    }
  end

  def data
    @records.map do |record|
      {}.tap do |h|
        self.class.fields.each do |f|
          h[f] = record.send(f)
        end
      end
    end
  end

  def self.collection(records, page_params = {})
    new(records, page_params).collection_for_json
  end
end
