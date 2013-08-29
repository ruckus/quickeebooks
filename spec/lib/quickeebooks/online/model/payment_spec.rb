describe "Quickeebooks::Online::Model::Payment" do

  it "parse invoice from XML" do
    xml = onlineFixture("payment.xml")
    invoice = Quickeebooks::Online::Model::Payment.from_xml(xml)
    invoice.id.value.should == "47"
    invoice.header.doc_number.should == "54"
    invoice.header.customer_id.value.should == "5"
    invoice.header.note.should == "Payment against Invoice"
    invoice.header.total_amount.should == 20.0

    invoice.line_items.count.should == 1
    invoice.line_items.first.amount.should == 20.0
    invoice.line_items.first.txn_id.value.should == "8"

    invoice.line_items.first.amount.should == invoice.header.total_amount
  end

end
