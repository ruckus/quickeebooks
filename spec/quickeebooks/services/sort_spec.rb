require "spec_helper"
require "fakeweb"
require "oauth"
require "quickeebooks"

describe "Quickeebooks::Service::Sort" do
  before(:all) do
  end
  
  it "can generate a sorting parameter" do
    filter = Quickeebooks::Service::Sort.new("FirstName", "NewestToOldest")
    filter.to_s.should == "FirstName NewestToOldest"
  end



end