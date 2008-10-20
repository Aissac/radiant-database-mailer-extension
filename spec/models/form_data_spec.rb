require File.dirname(__FILE__) + '/../spec_helper'

describe FormData do
  DATABASE_MAILER_COLUMNS.each_key do |key|
    it "defines named scope by_#{key}" do
      FormData.respond_to?(:"by_#{key}").should be_true
    end
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
    
    DATABASE_MAILER_COLUMNS.each_key do |key|
      it "filters by :#{key}" do
        foo = mock("proxy")
        foo.should_receive(:paginate)
        FormData.should_receive(:"by_#{key}").with('test').and_return(foo)
        FormData.form_paginate(key => 'test')
      end
    end
    
    it "finds urls" do
      FormData.should_receive(:find).with(:all, :group => 'url')
      FormData.find_all_group_by_url
    end
    
  end
end