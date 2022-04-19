class BaseFilter
  attr_accessor :params, :scope
  attr_reader :sort_field, :sort_direction

  def initialize(params, options = {})
    @params = params || {}
    @scope = options[:scope]
    @unsorted = options[:unsorted]

    @sort_field ||= 'created_at'
    @sort_direction ||= 'desc'

    @filtered_records = []
  end

  def self.filterable_fields
    @filterable_fields || {}
  end

  def self.filterable_attributes(filterable_fields = {})
    @filterable_fields = filterable_fields
  end

  def self.sortable_fields
    @sortable_fields || {}
  end

  def self.sortable_attributes(sortable_fields = {})
    @sortable_fields = sortable_fields
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

  def self.default_sort(field:, direction:)
    @sort_field = field
    @sort_direction = direction
  end

  def records
    return base_scope.none unless required_attributes?

    @records ||= begin
      @filtered_records = base_scope

      if params[:filter].present?
        filter_integer_fields
        filter_string_fields
        filter_boolean_fields
        filter_datetime_fields
      end

      sort_fields

      @filtered_records
    end
  end

  def sort_fields
    if params[:filter] && params[:filter][:sort]
      self.class.sortable_fields.include?(params[:filter][:sort][:field]) &&
        @sort_field =
          params[:filter][:sort][:field]

      %w[asc desc].include?(params[:filter][:sort][:direction]) &&
        @sort_direction =
          params[:filter][:sort][:direction]
    end

    if !@unsorted
      @filtered_records =
        @filtered_records.order(
          "#{table_name}.#{sort_field} #{sort_direction}"
        )
    end
  end

  def filter_integer_fields
    self.class.filterable_fields[:integer]&.each do |field|
      if filter_params[field].present?
        @filtered_records =
          @filtered_records.where(
            field => filter_params[field]
          )
      elsif filter_params.keys.include?(field)
        @filtered_records =
          @filtered_records.where(
            "\"#{table_name}\".\"#{field}\" is null"
          )
      end
    end
  end

  def filter_string_fields
    self.class.filterable_fields[:string]&.each do |field|
      if filter_params[field].present?
        @filtered_records =
          @filtered_records.where(
            "\"#{table_name}\".\"#{field}\" ILIKE ?",
            "%#{filter_params[field]}%"
          )
      elsif filter_params.keys.include?(field)
        @filtered_records =
          @filtered_records.where(
            "\"#{table_name}\".\"#{field}\" is null"
          )
      end
    end
  end

  def filter_boolean_fields
    self.class.filterable_fields[:boolean]&.each do |field|
      filter_params.keys.include?(field) &&
        @filtered_records =
          @filtered_records.where(
            field => filter_params[field]
          )
    end
  end

  def filter_datetime_fields
    self.class.filterable_fields[:datetime]&.each do |field|
      next unless filter_params.keys.include?(field)

      filter_params[field][:gt].present? &&
        @filtered_records =
          @filtered_records.where(
            @filtered_records.arel_table[field]
                             .gt(filter_params[field][:gt])
          )

      filter_params[field][:lt].present? &&
        @filtered_records =
          @filtered_records.where(
            @filtered_records.arel_table[field]
                             .lt(filter_params[field][:lt])
          )

      filter_params[field][:gteq].present? &&
        @filtered_records =
          @filtered_records.where(
            @filtered_records.arel_table[field]
                             .gteq(filter_params[field][:gteq])
          )

      filter_params[field][:lteq].present? &&
        @filtered_records =
          @filtered_records.where(
            @filtered_records.arel_table[field]
                             .lteq(filter_params[field][:lteq])
          )
    end
  end

  def base_scope
    raise OpenInterop::Errors::NotImplemented
  end

  def table_name
    raise OpenInterop::Errors::NotImplemented
  end

  def all_filterable_fields
    (
      self.class.filterable_fields[:integer] +
      self.class.filterable_fields[:string] +
      self.class.filterable_fields[:boolean] +
      (self.class.filterable_fields[:datetime] || []).map { |f| { f => %w[gt gteq lt lteq] } } +
      ['sort' => %w[field direction]]
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
