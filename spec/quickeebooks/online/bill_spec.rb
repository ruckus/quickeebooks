describe "Quickeebooks::Online::Model::Bill" do

  it "parse bill from XML" do
    xml = onlineFixture("bill.xml")
    bill = Quickeebooks::Online::Model::Bill.from_xml(xml)
    bill.header.doc_number.should == "2004"
    bill.header.vendor_id.value.should == "7"
    bill.header.sales_term_id.value.should == "5"
    bill.header.total_amount.should == 50

    bill.line_items.count.should == 1
    bill.line_items.first.amount.should == 25
    bill.line_items.first.billable_status.should == "NotBillable"
    bill.line_items.first.reimbursable.customer_id.value.should == "5"
  end

end
