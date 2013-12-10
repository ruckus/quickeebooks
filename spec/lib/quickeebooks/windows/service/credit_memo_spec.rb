describe "Quickeebooks::Windows::Service::CreditMemo" do
  before(:all) do
    construct_windows_service :credit_memo
  end

  it "can create an credit memo" do
    xml = windowsFixture("credit_memo_success_create.xml")
    model = Quickeebooks::Windows::Model::CreditMemo
    FakeWeb.register_uri(:post, @service.url_for_resource(model::REST_RESOURCE), :status => ["200", "OK"], :body => xml)

    credit_memo = Quickeebooks::Windows::Model::CreditMemo.new
    header = Quickeebooks::Windows::Model::CreditMemoHeader.new
    header.customer_id = Quickeebooks::Windows::Model::Id.new(2)
    header.due_date = Date.civil(2012, 7, 12).strftime('%F')
    header.ship_date = Date.civil(2012, 8, 11).strftime('%F')
    header.txn_date = Time.now.strftime('%F')
    header.doc_number = "12-225"

    billing_address = Quickeebooks::Windows::Model::Address.new
    billing_address.line1 = "100 S. Park Drive"
    billing_address.line2 = "Suite 200"
    billing_address.city = "San Jose"
    billing_address.postal_code = "95126"
    billing_address.country_sub_division_code = "CA"
    billing_address.tag = "Billing"

    shipping_address = Quickeebooks::Windows::Model::Address.new
    shipping_address.line1 = "999 Widmore Ave."
    shipping_address.city = "Santa Cruz"
    shipping_address.postal_code = "95060"
    shipping_address.country_sub_division_code = "CA"
    shipping_address.tag = "Shipping"

    header.billing_address = billing_address
    header.shipping_address = shipping_address

    payment = Quickeebooks::Windows::Model::PaymentDetail.new
    payment.credit_card = Quickeebooks::Windows::Model::CreditCard.new
    payment.credit_card.credit_charge_info = Quickeebooks::Windows::Model::CreditChargeInfo.new 
    cc = payment.credit_card.credit_charge_info 
    cc.number = '1111222233334444'
    cc.type = 'Visa'
    cc.name_on_acct = 'Bill Wilkerson'
    cc.cc_expiration_month = 3 
    cc.cc_expiration_year = 2016
    header.detail = payment

    item1 = Quickeebooks::Windows::Model::CreditMemoLineItem.new
    item1.item_id = Quickeebooks::Windows::Model::Id.new(4)
    item1.desc = "PVR2920"
    item1.unit_price = 144.00
    item1.quantity = 2.67
    credit_memo.line_items << item1
    credit_memo.header = header

    created_credit_memo = @service.create(credit_memo)

    created_credit_memo.success?.should == true
    created_credit_memo.success.object_ref.id.value.should == "9107908"
    created_credit_memo.success.request_name.should == "CreditMemoAdd"
  end

  it "can fetch a list of credit_memos" do
    xml = windowsFixture("credit_memos.xml")

    model = Quickeebooks::Windows::Model::CreditMemo
    FakeWeb.register_uri(:post, @service.url_for_resource(model::REST_RESOURCE), :status => ["200", "OK"], :body => xml)
    creditmemos = @service.list
    creditmemos.entries.count.should == 7

    creditmemo = creditmemos.entries.first
    creditmemo.id.value.should == "9107908"
    creditmemo.header.should_not == nil
    header = creditmemo.header
    header.doc_number.should == "12-225"
    header.txn_date.should == DateTime.parse('2012-07-10T00:00:00Z')
    header.customer_name.should == "Zanotto's Fine Grocer"

    header.remit_to_id.value.should == "2"
    header.remit_to_name.should == "Zanotto's Fine Grocer"
    header.ship_date.should == DateTime.parse('2012-07-11T00:00:00Z')
    header.sub_total_amount.should == 384.48
    header.tax_rate.should == 0
    header.total_amount.should == header.sub_total_amount
    header.to_be_printed.should == "false"
    header.to_be_emailed.should == "false"
    header.ar_account_id.value.should == "30"
    header.ar_account_name.should == "Accounts Receivable"
    header.due_date.should == DateTime.parse('2012-08-09T00:00:00Z')

    bill_addr = header.billing_address
    bill_addr.should_not == nil
    bill_addr.line1.should == "981 Lusk Blvd."
    bill_addr.city.should == "San Jose"
    bill_addr.state.should == "CA"
    bill_addr.postal_code.should == "95126"

    ship_addr = header.shipping_address
    ship_addr.should_not == nil
    ship_addr.line1.should == "981 Lusk Blvd."
    ship_addr.city.should == "San Jose"
    ship_addr.state.should == "CA"
    ship_addr.postal_code.should == "95126"

    header.bill_email.should == "thorn@zanottos.com"
    header.remaining_credit.should == header.total_amount

    line1 = creditmemo.line_items.first
    line1.should_not == nil
    line1.desc.should == "PVR2920"
    line1.amount.should == header.total_amount
    line1.item_id.value.should == "4"
    line1.item_name.should == "2005 Silver Oak Chardonnay"
    line1.unit_price.should == 144.00
    line1.quantity.should == 2.67
  end


  it "can fetch a sales receipt by ID" do
    xml = windowsFixture("fetch_credit_memo_by_id.xml")
    model = Quickeebooks::Windows::Model::CreditMemo
    FakeWeb.register_uri(:get, "#{@service.url_for_resource(model::REST_RESOURCE)}/341?idDomain=QB", :status => ["200", "OK"], :body => xml)
    sales_receipt = @service.fetch_by_id(341)
    sales_receipt.line_items.count.should eql 2
    sales_receipt.line_items.first.unit_price.should eql 1250.0
    sales_receipt.line_items.first.desc.should eql "Lessons"
  end

  it "can update a sales receipt" do
    xml = windowsFixture("credit_memo.xml")
    update_response_xml = windowsFixture("credit_memo_update_success.xml")
    model = Quickeebooks::Windows::Model::CreditMemo
    credit_memo = model.from_xml(xml)
    FakeWeb.register_uri(:post, @service.url_for_resource(model::REST_RESOURCE), :status => ["200", "OK"], :body => update_response_xml)
    update_response = @service.update(credit_memo)
    update_response.success?.should == true
    update_response.success.request_name.should == "CreditMemoModification"
  end

end
