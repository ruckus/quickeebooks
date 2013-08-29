describe "Quickeebooks::Online::Model::Invoice" do

  it "parse invoice from XML" do
    xml = onlineFixture("invoice.xml")
    invoice = Quickeebooks::Online::Model::Invoice.from_xml(xml)
    invoice.header.balance.should == 0
    invoice.id.value.should == "13"
    invoice.line_items.count.should == 1
    invoice.line_items.first.unit_price.should == 225
  end

end
