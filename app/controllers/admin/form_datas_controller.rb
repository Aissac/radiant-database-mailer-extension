class Admin::FormDatasController < ApplicationController

  require 'fastercsv'

  LIST_PARAMS_BASE = [:page, :sort_by, :sort_order]
  EXPORT_COLUMNS = FormData::SORT_COLUMNS.sort - ["exported"]
  def index
    @urls = FormData.find_all_group_by_url
    filter_by_params(FormData::FILTER_COLUMNS)
    respond_to do |format|
      format.html {
        @saved_items = FormData.form_paginate(list_params)
      }
      format.csv {
        exported_at = Time.now
        selected_export_columns = EXPORT_COLUMNS.reject{|k| params["export_#{k}"].blank?}
        csv_string = FormData.export(list_params, selected_export_columns, exported_at, !params[:include_all].blank?)
        send_data csv_string, 
         :type => "text/csv", 
         :filename => "export_#{exported_at.strftime("%Y-%m-%d_%H-%M")}.csv", 
         :disposition => 'attachment'
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

end
