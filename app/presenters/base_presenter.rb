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

  def collection_for_json
    @records =
      @records.page(@page_params[:number] || 1)
              .per(@page_params[:size] || 20)

    {
      total_records: @records.total_count,
      number_of_pages: @records.total_pages,
      page: { number: @records.current_page, size: @records.limit_value },
      data: data
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
