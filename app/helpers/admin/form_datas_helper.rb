module Admin::FormDatasHelper
  SORT_CYCLE = {'asc' => 'desc', 'desc' => 'none', 'none' => 'asc'}
  
  def sortable_column_head(label, attribute)
    current_order = (currently_sorting_by?(attribute) && %w(none asc desc).include?(list_params[:sort_order])) ? list_params[:sort_order] : 'none'
    dom_class = currently_sorting_by?(attribute) ? "sort_#{current_order}" : nil
    
    link_to(label,
      params.merge(list_params).merge(:sort_by => attribute, :sort_order => SORT_CYCLE[current_order], :reset => 1),
      :class => dom_class)
  end
  
  def filter_actions_tag
    submit_tag("Filter") + content_tag('span', ' | ' + reset_filters_tag)
  end
  
  def reset_filters_tag
    link_to("Reset", :reset => 1)
  end
  
  def each_data_column(&block)
    DATABASE_MAILER_COLUMNS.each_key do |key|
      yield key
    end
  end
  
  def data_columns
    DATABASE_MAILER_COLUMNS.keys
  end
  
  def date_format(timestamp)
    timestamp && timestamp.to_date.to_s(:rfc822)
  end
  
  def filters_present(&block)
    if (DATABASE_MAILER_COLUMNS.keys + [:url]).any? { |k| !list_params[k].blank?}
      yield
    end
  end
  
  def current_filters
    all_filters = DATABASE_MAILER_COLUMNS.keys + [:url]
    all_filters.map do |k|
      k unless list_params[k].blank?
    end.compact.join(", ")
  end
  
  def export_columns
    Admin::FormDatasController::EXPORT_COLUMNS
  end
  
  protected
  
  def currently_sorting_by?(attribute)
    list_params[:sort_by] == attribute.to_s
  end
end