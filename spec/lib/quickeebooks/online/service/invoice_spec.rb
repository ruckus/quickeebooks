describe "Quickeebooks::Online::Service::Invoice" do
  before(:all) do
    construct_online_service :invoice
  end

  it "can create an invoice" do
    xml = onlineFixture("invoice.xml")

    url = @service.url_for_resource(Quickeebooks::Online::Model::Invoice.resource_for_singular)
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"], :body => xml)
    invoice = Quickeebooks::Online::Model::Invoice.new
    invoice.header = Quickeebooks::Online::Model::InvoiceHeader.new
    invoice.header.doc_number = "123"

    line_item = Quickeebooks::Online::Model::InvoiceLineItem.new
    line_item.item_id = Quickeebooks::Online::Model::Id.new("123")
    line_item.desc = "Pinor Noir 2005"
    line_item.unit_price = 188
    line_item.quantity = 2
    invoice.line_items << line_item

    result = @service.create(invoice)
    result.id.value.to_i.should > 0
  end

  it "can delete an invoice" do
    fixture_xml = onlineFixture("invoice.xml")
    response_xml = onlineFixture("deleted_invoice.xml")

    invoice_id = "123"
    url = @service.url_for_resource(Quickeebooks::Online::Model::Invoice.resource_for_singular) + "/13?methodx=delete"
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"], :body => response_xml)
    invoice = Quickeebooks::Online::Model::Invoice.from_xml(fixture_xml)

    result = @service.delete(invoice)
  end

  it "can successfully download an invoice pdf" do
    destination_file_name = '/tmp/invoice.pdf'
    invoice_id = '123'
    url = "#{@service.url_for_resource("invoice-document")}/#{invoice_id}"
    FakeWeb.register_uri(:get, url, :status => ["200", "OK"], :body => '')
    File.should_receive(:open).with(destination_file_name, "wb")
    @service.invoice_as_pdf(invoice_id, destination_file_name).should == destination_file_name
  end

  it "should return nil and log the exception when failing to download an invoice pdf" do
    destination_file_name = '/tmp/invoice.pdf'
    invoice_id = '123'
    url = "#{@service.url_for_resource("invoice-document")}/#{invoice_id}"
    Quickeebooks.log = true
    strio = StringIO.new
    Quickeebooks.logger = ::Logger.new(strio)
    FakeWeb.register_uri(:get, url, :status => ["403", "Forbidden"], :body => '')
    @service.invoice_as_pdf(invoice_id, destination_file_name).should be_nil
    strio.string.should =~ /Error downloading.*#{destination_file_name}/
    Quickeebooks.logger = ::Logger.new($stdout)
    Quickeebooks.log = false
  end

end
