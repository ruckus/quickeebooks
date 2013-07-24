describe "Quickeebooks::Online::Model::SalesReceipt" do
  it "parse invoice from XML" do
    xml = onlineFixture("sales_receipt.xml")
    sales_receipt = Quickeebooks::Online::Model::SalesReceipt.from_xml(xml)
    sales_receipt.id.value.should == "8"
    sales_receipt.sync_token.should == 0
    sales_receipt.header.doc_number.should == "1006"
    sales_receipt.header.customer_id.value.should == "4"
    sales_receipt.header.subtotal_amount.should == 2500.00
    sales_receipt.header.total_amount.should == 2500.00

    line_item = sales_receipt.line_items.first
    line_item.desc.should == "Keyboards"
    line_item.amount.should == 2500.00
    line_item.unit_price.should == 10
    line_item.quantity.should == 2
  end
end
