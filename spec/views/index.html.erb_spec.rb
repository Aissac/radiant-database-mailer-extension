require File.dirname(__FILE__) + '/../spec_helper'

describe 'form_datas/index.html.erb' do
  before do    
    @list_params = {:url => "/contact/", :name => "test", :message => "test message", 
                    :email => "test@example.com", :company => "Aissac", :city => "Cluj",
                    :page => 1, :sort_by => "name", :sort_order => "asc"}
    template.stub!(:list_params).and_return(@list_params)
    
    @contact = mock_model(FormData, :url => '/contact/')
    @newsletter = mock_model(FormData, :url => '/newsletter/')
    assigns[:urls] = [@contact, @newsletter]
    
    @saved_items = (1..25).map { |i| stub_model(FormData, :name => "Data ##{i}") }.paginate(:page => 1, :per_page => 10)
    assigns[:saved_items] = @saved_items
  end
  
  def do_render
    render '/admin/form_datas/index.html.haml'
  end
  
  it "renders" do
    do_render
  end
end