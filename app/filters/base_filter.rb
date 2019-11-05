class BaseFilter
  attr_accessor :params, :scope

  def initialize(params, options = {})
    @params = params || {}
    @scope = options[:scope]

    @filtered_records = []
  end

  def self.filterable_fields
    @filterable_fields || {}
  end

  def self.filterable_attributes(filterable_fields = {})
    @filterable_fields = filterable_fields
  end

  def self.required_or_field
    @required_or_field || []
  end

  def self.require_one_of(required_or_field = [])
    @required_or_field = required_or_field
  end

  def self.required_and_field
    @required_and_field || []
  end

  def self.required_fields(required_and_field = [])
    @required_and_field = required_and_field
  end

  def records
    return base_scope.none unless required_attributes?

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
      filter_params[field].present? &&
        @filtered_records =
          @filtered_records.where(
            field => filter_params[field]
          )
    end
  end

  def filter_string_fields
    self.class.filterable_fields[:string].each do |field|
      filter_params[field].present? &&
        @filtered_records =
          @filtered_records.where(
            "\"#{table_name}\".\"#{field}\" ILIKE ?",
            "%#{filter_params[field]}%"
          )
    end
  end

  def filter_boolean_fields
    self.class.filterable_fields[:boolean].each do |field|
      filter_params.keys.include?(field) &&
        @filtered_records =
          @filtered_records.where(
            field => filter_params[field]
          )
    end
  end

  def base_scope
    raise 'Not implemented'
  end

  def table_name
    raise 'Not implemented'
  end

  def all_filterable_fields
    (
      self.class.filterable_fields[:integer] +
      self.class.filterable_fields[:string] +
      self.class.filterable_fields[:boolean]
    ).flatten
  end

  def filter_params
    params.fetch(:filter).permit(all_filterable_fields)
  end

  def required_attributes?
    self.class.required_and_field.all? { |f| params[:filter]&.include?(f) } &&
      (
        self.class.required_or_field.blank? ||
          self.class.required_or_field.any? { |f| params[:filter]&.include?(f) }
      )
  end

  def self.records(filter_params, options = {})
    new(filter_params, options).records
  end
end
