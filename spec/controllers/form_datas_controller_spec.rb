require File.dirname(__FILE__) + '/../spec_helper'

describe Admin::FormDatasController do
  scenario :users
  
  describe  'handling GET index' do
  
    before do
      login_as :developer
      
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
      controller.should_receive(:filter_by_params).with(DATABASE_MAILER_COLUMNS.keys + [:url])
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
      request.cookies[key] = CGI::Cookie.new('name' => key, 'value' => value)
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
      response.cookies['page'].should == ['99']
    end
    
    it "should reset list_params when params[:reset] == 1" do
      set_cookie('page', '98')
      do_get(:reset => 1)
      filter_by_params
      response.cookies['page'].should == ["1"]
    end
    it "should set params[:page] if loading from cookies (required for will_paginate to work)" do
      set_cookie('page', '98')
      do_get
      filter_by_params
      params[:page].should == '98'
    end
  end
end