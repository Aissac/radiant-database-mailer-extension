require File.dirname(__FILE__) + '/../spec_helper'

describe FormData do
  DATABASE_MAILER_COLUMNS.each_key do |key|
    it "defines named scope by_#{key}" do
      FormData.respond_to?(:"by_#{key}").should be_true
    end
  end
  
  it "finds urls" do
    FormData.should_receive(:find).with(:all, :group => 'url')
    FormData.find_all_group_by_url
  end
  
  describe "handling #form_paginate" do
    FormData::SORT_COLUMNS.each do |col|
      it "sorts by known column #{col}" do
        FormData.should_receive(:paginate).with(:order => "#{col} asc", :page => 1, :per_page => 10)
        FormData.form_paginate(:sort_by => col, :sort_order => 'asc', :page => 1)
      end
    end
    
    it "does not sort by unknown column" do
      FormData.should_receive(:paginate).with(:page => 1, :per_page => 10)
      FormData.form_paginate(:sort_by => "test", :sort_order => 'asc', :page => 1)
    end
    
    it "does not sort by unknown order attribute" do
      FormData.should_receive(:paginate).with(:page => 1, :per_page => 10)
      FormData.form_paginate(:sort_by => "name", :sort_order => 'test', :page => 1)
    end
    
    FormData::FILTER_COLUMNS.each do |key|
      it "filters by :#{key}" do
        foo = mock("proxy")
        foo.should_receive(:paginate)
        FormData.should_receive(:"by_#{key}").with('test').and_return(foo)
        FormData.form_paginate(key => 'test')
      end
    end
  end
    
  describe "handling #find_for_export" do
    FormData::SORT_COLUMNS.each do |col|
      it "sorts by known column #{col}" do
        FormData.should_receive(:find).with(:all, :order => "#{col} asc")
        FormData.find_for_export({:sort_by => col, :sort_order => 'asc'}, false)
      end
    end
    
    it "does not sort by unknown column" do
      FormData.should_receive(:find)
      FormData.find_for_export({:sort_by => "test", :sort_order => 'asc'}, false)
    end

    it "does not sort by unknown order attribute" do
      FormData.should_receive(:find)
      FormData.find_for_export({:sort_by => "name", :sort_order => 'test'}, false)
    end
    
    FormData::FILTER_COLUMNS.each do |key|
      it "filters by :#{key} and not_exported" do
        filter_by_key_scope = mock("named_scope :by_#{key}")
        filter_by_key_scope.should_receive(:find)
        
        not_exported_scope = mock("named_scope :not_exported")
        FormData.should_receive(:not_exported).and_return(not_exported_scope)
        
        not_exported_scope.should_receive(:"by_#{key}").with('test').and_return(filter_by_key_scope)
        
        FormData.find_for_export({key => 'test'}, false)
      end
      
      it "filters by :#{key} including exported" do
        filter_by_key_scope = mock("named_scope :by_#{key}")
        filter_by_key_scope.should_receive(:find)
        
        FormData.should_receive(:"by_#{key}").with('test').and_return(filter_by_key_scope)
        
        FormData.find_for_export({key => 'test'}, true)
      end
    end
  end
  
  describe "handling #export_csv" do
    before do
      @jerry = mock_model(FormData, :name => "Jerry", :message => "Superman", :url => '/newsletter/', :exported= => nil, :save => true)
      @george = mock_model(FormData,:name => "George", :message => "I'm out, baby!", :url => '/contact/', :exported= => nil, :save => true)
      @form_datas = [@jerry, @george]
      FormData.stub!(:find_for_export).and_return(@form_datas)
      
      @export_params = mock("export params")
      @time = Time.now
    end
    
    def do_export(columns=%w(name message url))
      FormData.export_csv(@export_params, columns, @time, false)
    end
    
    it "finds items for export" do
      FormData.should_receive(:find_for_export).with(@export_params, false).and_return(@form_datas)
      do_export
    end
    
    it "marks exported time for each item" do
      @form_datas.each do |fd|
        fd.should_receive(:exported=).with(@time.to_s(:db))
        fd.should_receive(:save).and_return(true)
      end
      do_export
    end
    
    it "generates csv for all columns" do
      do_export.should == "Name,Message,Url\nJerry,Superman,/newsletter/\nGeorge,\"I'm out, baby!\",/contact/\n"
    end
    
    it "generates csv for selected columns" do
      do_export(%w(name url)).should == "Name,Url\nJerry,/newsletter/\nGeorge,/contact/\n"
    end
  end
  
  describe "handling #export_xls" do
    
    before do
      @jerry = mock_model(FormData, :name => "Jerry", :message => "Superman", :url => '/newsletter/', :exported= => nil, :save => true)
      @george = mock_model(FormData,:name => "George", :message => "I'm out, baby!", :url => '/contact/', :exported= => nil, :save => true)
      @form_datas = [@jerry, @george]
      FormData.stub!(:find_for_export).and_return(@form_datas)

      @export_params = mock("export params")
      @time = Time.now
    end
      
    def do_export(columns=%w(name message url))
      FormData.export_xls(@export_params, columns, @time, false)
    end
    
    it "finds items for export" do
      FormData.should_receive(:find_for_export).with(@export_params, false).and_return(@form_datas)
      do_export
    end
    
    it "marks exported time for each item" do
      @form_datas.each do |fd|
        fd.should_receive(:exported=).with(@time.to_s(:db))
        fd.should_receive(:save).and_return(true)
      end
      do_export
    end
  end
end