require "spec_helper"

require "quickeebooks/customer"

describe "Quickeebooks::Customer" do
  
  describe "parse customer from XML" do
    xml = File.read(File.dirname(__FILE__) + "/../xml/customer.xml")
    customer = Quickeebooks::Customer.from_xml(xml)
    customer.syncToken.should == 1
    customer.name.should == "John Doe"
    
    create_time = Date.civil(2011, 9, 29)
    customer.meta_data.create_time.year.should == create_time.year
  end
  
end