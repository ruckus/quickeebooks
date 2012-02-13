require "spec_helper"

require "quickeebooks/model/customer"

describe "Quickeebooks::Model::Customer" do
  
  describe "parse customer from XML" do
    xml = File.read(File.dirname(__FILE__) + "/../xml/customer.xml")
    customer = Quickeebooks::Model::Customer.from_xml(xml)
    customer.syncToken.should == 1
    customer.name.should == "John Doe"
    
    create_time = Date.civil(2011, 9, 29)
    customer.meta_data.create_time.year.should == create_time.year
    customer.addresses.count.should == 2
    
    customer.addresses.first.line1.should == "123 Main St."
    
    customer.phones.size.should == 2
    customer.phones.first.free_form_number.should == "(408) 555-1212"
    
    customer.email.address.should == "johndoe@gmail.com"
    
    customer.notes.count.should == 1
    customer.notes.first.content.should == "Likes chocolate and horses"

    customer.custom_fields.count.should == 3

    customer.open_balance.amount.should == 6200.0
  end
  
end