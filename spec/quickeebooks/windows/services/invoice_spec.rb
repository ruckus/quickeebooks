describe "Quickeebooks::Windows::Service::Invoice" do
  before(:all) do
    construct_windows_service :invoice
  end

  it "can fetch a list of invoices" do
    xml = windowsFixture("invoices.xml")

    model = Quickeebooks::Windows::Model::Invoice
    FakeWeb.register_uri(:post, @service.url_for_resource(model::REST_RESOURCE), :status => ["200", "OK"], :body => xml)
    invoices = @service.list
    invoices.entries.count.should == 7

    invoice = invoices.entries.first
    invoice.id.value.should == "9107908"
    invoice.header.should_not == nil
    header = invoice.header
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
    header.balance.should == header.total_amount

    line1 = invoice.line_items.first
    line1.should_not == nil
    line1.desc.should == "PVR2920"
    line1.amount.should == header.total_amount
    line1.item_id.value.should == "4"
    line1.item_name.should == "2005 Silver Oak Chardonnay"
    line1.unit_price.should == 144.00
    line1.quantity.should == 2.67
  end

  it "can create an invoice" do
    xml = windowsFixture("invoice_success_create.xml")

    model = Quickeebooks::Windows::Model::Invoice
    FakeWeb.register_uri(:post, @service.url_for_resource(model::REST_RESOURCE), :status => ["200", "OK"], :body => xml)

    invoice = Quickeebooks::Windows::Model::Invoice.new
    header = Quickeebooks::Windows::Model::InvoiceHeader.new
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

    item1 = Quickeebooks::Windows::Model::InvoiceLineItem.new
    item1.item_id = Quickeebooks::Windows::Model::Id.new(4)
    item1.desc = "PVR2920"
    item1.unit_price = 144.00
    item1.quantity = 2.67

    invoice.line_items << item1
    invoice.header = header

    created_invoice = @service.create(invoice)

    created_invoice.success?.should == true
    created_invoice.success.object_ref.id.value.should == "9107908"
    created_invoice.success.request_name.should == "InvoiceAdd"
  end

  it "can fetch an Invoice by ID" do
    xml = windowsFixture("invoice.xml")
    model = Quickeebooks::Windows::Model::Invoice
    FakeWeb.register_uri(:get, "#{@service.url_for_resource(model::REST_RESOURCE)}/40154?idDomain=QB", :status => ["200", "OK"], :body => xml)
    invoice = @service.fetch_by_id('40154')
    invoice.header.doc_number.should == "1515"
  end

  it "can update an invoice" do
    invoice_xml = windowsFixture("invoice_2.xml")
    update_response_xml = windowsFixture("invoice_update_success.xml")
    model = Quickeebooks::Windows::Model::Invoice
    invoice = model.from_xml(invoice_xml)
    invoice.header.customer_name.should == "Cafe Smith"

    FakeWeb.register_uri(:post, @service.url_for_resource(model::REST_RESOURCE), :status => ["200", "OK"], :body => update_response_xml)

    # alter the note
    invoice.header.note = "an updated note"
    update_response = @service.update(invoice)
    update_response.success?.should == true
    update_response.success.object_ref.id.value.should == "98"
    update_response.success.request_name.should == "InvoiceMod"
  end

end
