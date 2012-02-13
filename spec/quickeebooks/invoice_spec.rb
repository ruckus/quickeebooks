require "spec_helper"

require "quickeebooks/model/invoice"

describe "Quickeebooks::Model::Invoice" do
  
  describe "parse invoice from XML" do
    xml = File.read(File.dirname(__FILE__) + "/../xml/invoice.xml")
    invoice = Quickeebooks::Model::Invoice.from_xml(xml)
    invoice.id.should == 28
    invoice.line_items.count.should == 1
    invoice.line_items.first.unit_price.should == 100
  end
  
end