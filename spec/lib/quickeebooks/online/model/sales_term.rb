describe "Quickeebooks::Online::Model::SalesTerm" do
  it "parse invoice from XML" do
    xml = onlineFixture("sales_term.xml")
    sales_receipt = Quickeebooks::Online::Model::SalesTerm.from_xml(xml)
    sales_receipt.id.value.should == "1"
    sales_receipt.name.should == "Due on receipt"
    sales_receipt.due_days.should == 0
    sales_receipt.discount_days.should == 0
  end
end
