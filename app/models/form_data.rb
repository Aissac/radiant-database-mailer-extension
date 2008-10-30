class FormData < ActiveRecord::Base

  DATABASE_MAILER_COLUMNS.each_key do | col |
    FormData.named_scope :"by_#{col}", lambda { |item|
      {:conditions => ["LOWER(#{col}) LIKE ?", "%#{item.to_s.downcase}%"]}
    }
  end
  named_scope :by_url, lambda{ |item| {:conditions => ["url = ?", item]}}
  
  SORT_COLUMNS = DATABASE_MAILER_COLUMNS.keys.map(&:to_s) + ['created_at', 'url', 'exported']

  def self.form_paginate(params)
    options = {
      :page => params[:page],
      :per_page => 10,
    }
    if SORT_COLUMNS.include?(params[:sort_by]) && %w(asc desc).include?(params[:sort_order])
      options[:order] = "#{params[:sort_by]} #{params[:sort_order]}"
    end
    params.reject { |k, v| [:page, :sort_by, :sort_order].include?(k) }.
      inject(FormData) { |scope, pair| pair[1].blank? ? scope : scope.send(:"by_#{pair[0]}", pair[1]) }.
      paginate(options)
  end
  
  def self.find_for_export(params)
    options = {}
    if SORT_COLUMNS.include?(params[:sort_by]) && %w(asc desc).include?(params[:sort_order])
      options[:order] = "#{params[:sort_by]} #{params[:sort_order]}"
    end
    params.reject { |k, v| [:page, :sort_by, :sort_order].include?(k) }.
      inject(FormData) { |scope, pair| pair[1].blank? ? scope : scope.send(:"by_#{pair[0]}", pair[1]) }.find(:all, :order => options[:order])
  end

  def self.find_all_group_by_url
     find(:all, :group => 'url')
  end

  def initialize(params={})
    data = params.dup.delete_if { |k, v| !self.class.column_names.include?(k.to_s) }
    super(data)
  end
end