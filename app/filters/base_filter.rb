class BaseFilter
  attr_accessor :params, :scope

  def initialize(params, options = {})
    @params = params || {}
    @scope = options[:scope]

    @filtered_records = []
  end

  def self.filterable_fields
    @filterable_fields
  end

  def self.filterable_attributes(filterable_fields = {})
    @filterable_fields = filterable_fields
  end

  def records
    @records ||= begin
      @filtered_records = base_scope

      if params[:filter]
        filter_integer_fields
        filter_string_fields
        filter_boolean_fields
      end

      @filtered_records
    end
  end

  def filter_integer_fields
    self.class.filterable_fields[:integer].each do |field|
      filter_params[field.camelize(:lower)].present? &&
        @filtered_records =
          @filtered_records.where(
            field => filter_params[field.camelize(:lower)]
          )
    end
  end

  def filter_string_fields
    self.class.filterable_fields[:string].each do |field|
      filter_params[field.camelize(:lower)].present? &&
        @filtered_records =
          @filtered_records.where(
            "\"transmissions\".\"#{field}\" ILIKE ?",
            "%#{filter_params[field.camelize(:lower)]}%"
          )
    end
  end

  def filter_boolean_fields
    self.class.filterable_fields[:boolean].each do |field|
      filter_params.keys.include?(field) &&
        @filtered_records =
          @filtered_records.where(
            field => filter_params[field.camelize(:lower)]
          )
    end
  end

  def base_scope
    raise 'Not implemented'
  end

  def all_filterable_fields
    (
      self.class.filterable_fields[:integer] +
      self.class.filterable_fields[:string] +
      self.class.filterable_fields[:boolean]
    ).map { |f| [f, f.camelize(:lower)] }.flatten
  end

  def filter_params
    params.fetch(:filter).permit(all_filterable_fields)
  end

  def self.records(filter_params, options)
    new(filter_params, options).records
  end
end
