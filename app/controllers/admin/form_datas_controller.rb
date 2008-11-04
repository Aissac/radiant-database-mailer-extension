class Admin::FormDatasController < ApplicationController

  require 'fastercsv'

  LIST_PARAMS_BASE = [:page, :sort_by, :sort_order]
  EXPORT_COLUMNS = FormData::SORT_COLUMNS.sort
  def index
    @urls = FormData.find_all_group_by_url
    filter_by_params(FormData::FILTER_COLUMNS)
    respond_to do |format|
       format.html {
         @saved_items = FormData.form_paginate(list_params)
        }
       format.csv { 
         @export_items = FormData.find_for_export(list_params, !params[:include_all].blank?)
         export_fields 
       }
     end
  end
  
  def list_params
    @list_params ||= {}
  end
  helper_method :list_params
  
  protected
    def filter_by_params(args)
      args = args + LIST_PARAMS_BASE
      args.each do |arg|
        list_params[arg] = params[:reset] ? params[arg] : params[arg] || cookies[arg]
      end
      list_params[:page] ||= "1"
    
      update_list_params_cookies(args)
    
      # pentru will_paginate
      params[:page] = list_params[:page]
    end
  
    def update_list_params_cookies(args)
      args.each do |key|
        cookies[key] = { :value => list_params[key], :path => "/#{controller_path}" }
      end
    end
    
    def export_fields
      selected_export_columns = EXPORT_COLUMNS.reject{|k| params["export_#{k}"].blank?}
      csv_string = FasterCSV.generate do |csv|
        csv << selected_export_columns.map{|k| k.capitalize}
        @export_items.each do |ei|
          csv << selected_export_columns.map do |k|
            formatting_for_csv(ei.send(k))
          end
        end
      end

      send_data csv_string, 
       :type => "text/csv", 
       :filename => "export_#{Time.now.strftime("%Y-%m-%d_%H-%M")}.csv", 
       :disposition => 'attachment'
    end
    
    def formatting_for_csv(item)
      if Time === item
        item.to_s(:db)
      else
        item.to_s.gsub(/([^\n]\n)(?=[^\n])/, ' ')
      end
    end
end



# if include_all?
#   @export_items.each do |ei|
#     csv << selected_export_columns.map do |k| 
#       if date_related?(k.to_s) 
#         (ei.send(k).blank? ? Time.now.to_s(:db) : ei.send(k).to_s(:db))
#       else
#         ei.send(k).blank? ? "" : clean(ei.send(k))
#       end
#     end
#   end
# else
#   @export_items.reject{|k| !k.exported.nil?}.each do |ei|
#     csv << selected_export_columns.map do |k| 
#       if date_related?(k.to_s) 
#         (ei.send(k).blank? ? Time.now.to_s(:db) : ei.send(k).to_s(:db))
#       else
#         ei.send(k).blank? ? "" : clean(ei.send(k))
#       end
#     end
#   end
# end