describe "Quickeebooks::Online::Model::BillPayment" do

  describe "parse bill payment from XML" do
    it "should properly parse bill payment from XML" do
      xml = onlineFixture("bill_payment.xml")
      bill_payment = Quickeebooks::Online::Model::BillPayment.from_xml(xml)
      bill_payment.id.value.should == '13'
      bill_payment.sync_token.should == 0
      bill_payment.header.doc_number.should == '15'
      bill_payment.header.entity_id.value.should == '1'
      bill_payment.header.total_amount.should == 5000.0
      bill_payment.line_items.size.should == 1
      bill_payment.line_items[0].amount.should == 5000.0
      bill_payment.line_items[0].txn_id.value.should == '12'
    end
  end

end
