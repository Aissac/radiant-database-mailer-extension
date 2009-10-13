require File.dirname(__FILE__) + '/../spec_helper'

describe Admin::FormDatasController do
  dataset :users
  
  before :each do
    login_as :designer
  end
  
  describe  'handling GET index' do
  
    before do
      @form_datas = (1..10).map {|i| mock_model(FormData) }
      @urls = (1..4).map {|i| mock_model(FormData)}
      
      FormData.stub!(:form_paginate).and_return(@form_datas)
      FormData.stub!(:find_all_group_by_url).and_return(@urls)
      @list_params = mock("list_params")
      controller.stub!(:filter_by_params)
    end
  
    def do_get
      get :index
    end
  
    it "should be succesful" do
      do_get
      response.should be_success
    end
  
    it "should render index template" do
      do_get
      response.should render_template('index')
    end
  
    it "should parse list_params" do
      controller.should_receive(:filter_by_params).with(FormData::FILTER_COLUMNS)
      do_get
    end
  
    it "should find all saved items with list_params" do
      controller.should_receive(:list_params).and_return(@list_params)
      FormData.should_receive(:form_paginate).with(@list_params).and_return(@form_datas)
      do_get
    end
  
    it "should assign the found saved items for the view" do
      do_get
      assigns[:saved_items].should == @form_datas
    end
    
    it "should assign the found urls for the view" do
      do_get
      assigns[:urls].should == @urls
    end
  end
  
  describe "handling GET show" do
    before(:each) do
      @form_data = mock_model(FormData)
      FormData.stub!(:find).and_return(@form_data)
    end
    
    def do_get
      get :show, :id => @form_data.id
    end
    
    it "is successful" do
      do_get
      response.should be_success
    end
    
    it "finds the corresponding form_data and assigns it to the view" do
      FormData.should_receive(:find).with(@form_data.id.to_s).and_return(@form_data)
      do_get
      assigns[:form_data].should == @form_data
    end
    
  end

  describe 'handling GET index.csv' do
    before do
      @list_params = mock("list_params")
      controller.stub!(:list_params).and_return(@list_params)
      controller.stub!(:filter_by_params)
      
      t = Time.now
      @time = mock("time", :to_s => 'time', :to_f => t.to_f, :to_i => t.to_i, :strftime => 'time')
      Time.stub!(:now).and_return(@time)

      FormData.stub!(:export_csv).and_return('csv')
      controller.stub!(:send_data)
      
      @request.accept = "text/csv" #=> request JS
    end
    
    def do_get(options={})
      get :index, options, :format => 'csv'
    end
    
    it "is succesful" do
      do_get
      response.should be_redirect
    end    
    
    it "parses list_params" do
      controller.should_receive(:filter_by_params).with(FormData::FILTER_COLUMNS)
      do_get
    end
    
    it "passes the selected_export_columns" do
      FormData.should_receive(:export_csv).with(@list_params, %w(name url), @time, false).and_return('csv')
      do_get({:export_name => "name", :export_url => "url"})
    end
    
    it "passes the include_all columns" do
      FormData.should_receive(:export_csv).with(@list_params, [], @time, true).and_return('csv')
      do_get({:include_all => "yes"})
    end
    
    it "sends data as csv string" do
      FormData.should_receive(:export_csv).and_return('csv_string')
      controller.should_receive(:send_data).with("csv_string", {:type=>"text/csv", :filename=>"export_#{@time.to_s}.csv", :disposition=>"attachment"})
      do_get
    end
  end
  
  describe "handling GET index.xls" do
    before do
      @list_params = mock("list_params")
      controller.stub!(:list_params).and_return(@list_params)
      controller.stub!(:filter_by_params)
      
      t = Time.now
      @time = mock("time", :to_s => 'time', :to_f => t.to_f, :to_i => t.to_i, :strftime => 'time')
      Time.stub!(:now).and_return(@time)

      FormData.stub!(:export_xls).and_return('xls')
      controller.stub!(:send_file)
    end
    
    def do_get(options={})
      get :index, options.merge(:format => 'xls')
    end
    
    it "is succesful" do
      do_get
      response.should be_success
    end
    
    it "parses list_params" do
      controller.should_receive(:filter_by_params).with(FormData::FILTER_COLUMNS)
      do_get
    end
    
    it "passes the selected_export_columns" do
      FormData.should_receive(:export_xls).with(@list_params, %w(name url), @time, false).and_return('xls')
      do_get({:export_name => "name", :export_url => "url"})
    end
    
    it "passes the include_all columns" do
      FormData.should_receive(:export_xls).with(@list_params, [], @time, true).and_return('xls')
      do_get({:include_all => "yes"})
    end
    
    it "sends data as csv string" do
      FormData.should_receive(:export_xls).and_return('xls_file')
      controller.should_receive(:send_file).with("xls_file", {:type=>"application/vnd.ms-excel", :filename=>"form_data_#{@time.to_s}.xls", :disposition=>"attachment"})
      do_get
    end
    
  end

  describe "parsing list_params" do
    
    def do_get(options={})
      get :index, options
    end
  
    def filter_by_params(args=[])
      @controller.send(:filter_by_params, args)
    end
    
    def list_params
      @controller.send(:list_params)
    end
    
    def set_cookie(key, value)
      # request.cookies[key] = CGI::Cookie.new('name' => key, 'value' => value)
      request.cookies[key] = value
    end
  
    it "should have default set of params" do
      do_get
      filter_by_params
      [:page, :sort_by, :sort_order].each {|p| response.cookies.keys.should include(p.to_s)}
    end
    
    it "should take arbitrary params" do
      do_get(:name => 'Blah', :test => 10)
      filter_by_params([:name, :test])
      [:name, :test].each {|p| response.cookies.keys.should include(p.to_s)}
    end
        
    it "should load list_params from cookies by default" do
      set_cookie('page', '98')
      do_get
      filter_by_params
      list_params[:page].should == '98'
    end
    
    it "should prefer request params over cookies" do
      set_cookie('page', '98')
      do_get(:page => '99')
      filter_by_params
      list_params[:page].should == '99'
    end
    
    it "should update cookies with new values" do
      set_cookie('page', '98')
      do_get(:page => '99')
      filter_by_params
      response.cookies['page'].should == '99'
    end
    
    it "should reset list_params when params[:reset] == 1" do
      set_cookie('page', '98')
      do_get(:reset => 1)
      filter_by_params
      response.cookies['page'].should == "1"
    end
    it "should set params[:page] if loading from cookies (required for will_paginate to work)" do
      set_cookie('page', '98')
      do_get
      filter_by_params
      params[:page].should == '98'
    end
  end

  describe "handling DELETE destroy" do
    
    before do
      @form_data = mock_model(FormData)
      FormData.stub!(:find).and_return(@form_data)
      @form_data.stub!(:destroy)
    end
    
    def do_delete
      delete :destroy, :id => @form_data.id
    end
    
    it "finds the coresponding record" do
      FormData.should_receive(:find).with(@form_data.id.to_s).and_return(@form_data)
      do_delete
    end
    
    it "destroys the record" do
      @form_data.should_receive(:destroy)
      do_delete
    end
    
    it "assigns flash message" do
      do_delete
      flash[:notice].should == "Record deleted!"
    end
    
    it "redirects on success" do
      do_delete
      response.should be_redirect
    end
  end
end