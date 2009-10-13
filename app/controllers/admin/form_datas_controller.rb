class Admin::FormDatasController < ApplicationController

  require 'fastercsv'
  before_filter :attach_assets
  LIST_PARAMS_BASE = [:page, :sort_by, :sort_order]
  EXPORT_COLUMNS = FormData::SORT_COLUMNS.sort - ["exported"] + ["blob"]
  def index

    @urls = FormData.find_all_group_by_url
    filter_by_params(FormData::FILTER_COLUMNS)
    respond_to do |format|
      format.html {
        @saved_items = FormData.form_paginate(list_params)
      }
      
      exported_at = Time.now
      selected_export_columns = EXPORT_COLUMNS.reject{|k| params["export_#{k}"].blank?}
      
      format.csv {
        csv_string = FormData.export_csv(list_params, selected_export_columns, exported_at, !params[:include_all].blank?)
        send_data csv_string, 
         :type => "text/csv", 
         :filename => "export_#{exported_at.strftime("%Y-%m-%d_%H-%M")}.csv", 
         :disposition => 'attachment'
       }
       format.xls {
         xls_path = FormData.export_xls(list_params, selected_export_columns, exported_at, !params[:include_all].blank?)
         send_file xls_path,
          :type => "application/vnd.ms-excel", 
          :filename => "form_data_#{exported_at.strftime("%Y-%m-%d_%H-%M")}.xls", 
          :disposition => 'attachment'
       }
     end
  end
  
  def show
    @form_data = FormData.find(params[:id])
  end
  
  def destroy
    @form_data = FormData.find(params[:id])
    @form_data.destroy
    flash[:notice] = "Record deleted!"
    redirect_to admin_form_datas_path
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
    
    def attach_assets
      include_stylesheet "admin/database_mailer"
      include_javascript "admin/database_mailer"
    end

end
