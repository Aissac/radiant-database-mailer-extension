require File.dirname(__FILE__) + '/../spec_helper'

describe MailController do
  dataset :users, :mailers
  
  before do
    login_as :designer
    @form_data = mock_model(FormData)
    FormData.stub!(:create)
  end
  
  def do_post(options={})
    post :create, {:page_id => page_id(:contact), :mailer => {}}.merge(options)
  end
  
  it "redirects to /contact-success on success" do
    do_post
    response.should redirect_to('/contact/thank-you')
  end
  
  it "creates a new FormData from mailer params" do
    FormData.should_receive(:create).and_return(@form_data)
    do_post
  end
  
  it "passes the page url to the new form data" do
    FormData.should_receive(:create).with("url" => "/contact/", "blob" => "").and_return(@form_data)
    do_post
  end
  
  it "passes mailer params to the new for data" do
    FormData.should_receive(:create).with("name" => "piki", "url" => "/contact/", "blob" => "").and_return(@form_data)
    do_post(:mailer => {"name" => 'piki'})
  end
  
  it "does not create FormData when save_to_database config is false" do
    FormData.should_not_receive(:create)
    do_post(:page_id => page_id(:contact_no_save))
  end
end