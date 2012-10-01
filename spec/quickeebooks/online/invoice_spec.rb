require "spec_helper"

require "quickeebooks/online/model/invoice"

describe "Quickeebooks::Online::Model::Invoice" do
  
  describe "parse invoice from XML" do
    xml = File.read(File.dirname(__FILE__) + "/../../xml/online/invoice.xml")
    invoice = Quickeebooks::Online::Model::Invoice.from_xml(xml)
    invoice.header.balance.should == 0
    invoice.id.value.should == "13"
    invoice.line_items.count.should == 1
    invoice.line_items.first.unit_price.should == 225
  end
  
end
