require File.dirname(__FILE__) + '/../spec_helper'

describe FormDataAsset do
  before(:each) do
    @form_data_asset = FormDataAsset.new
  end

  it "should be valid" do
    @form_data_asset.should be_valid
  end
end
