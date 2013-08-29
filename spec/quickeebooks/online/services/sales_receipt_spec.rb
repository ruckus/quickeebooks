describe "Quickeebooks::Online::Service::SalesReceipt" do
  before(:all) do
    construct_online_service :sales_receipt
  end

  it "can fetch a list of sales receipts" do
    xml = onlineFixture("sales_receipts.xml")
    url = @service.url_for_resource(Quickeebooks::Online::Model::SalesReceipt.resource_for_collection)
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"], :body => xml)
    sales_receipts = @service.list
    sales_receipts.current_page.should == 1
    sales_receipts.entries.count.should == 1
    sales_receipts.entries.first.header.doc_number.should == "1006"
  end

  it "can create a sales receipt" do
    xml = onlineFixture("sales_receipt.xml")
    url = @service.url_for_resource(Quickeebooks::Online::Model::SalesReceipt.resource_for_singular)
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"], :body => xml)
    sales_receipt = Quickeebooks::Online::Model::SalesReceipt.new
    sales_receipt.header = Quickeebooks::Online::Model::SalesReceiptHeader.new
    sales_receipt.header.note = "Sales receipt for keyboards"
    sales_receipt.header.total_amount = 25.00
    sales_receipt.header.doc_number = 1005
    result = @service.create(sales_receipt)
    result.id.value.to_i.should > 0
  end

  it "can delete a sales receipt" do
    url = "#{@service.url_for_resource(Quickeebooks::Online::Model::SalesReceipt.resource_for_singular)}/5?methodx=delete"
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"])
    sales_receipt = Quickeebooks::Online::Model::SalesReceipt.new
    sales_receipt.id = Quickeebooks::Online::Model::Id.new("5")
    sales_receipt.sync_token = 0
    result = @service.delete(sales_receipt)
    result.should == true
  end

  it "can fetch a sales receipt by id" do
    xml = onlineFixture("sales_receipt.xml")
    url = "#{@service.url_for_resource(Quickeebooks::Online::Model::SalesReceipt.resource_for_singular)}/47"
    FakeWeb.register_uri(:get, url, :status => ["200", "OK"], :body => xml)
    sales_receipt = @service.fetch_by_id(47)
    sales_receipt.header.doc_number.should == "1006"
  end

  it "can update a sales receipt" do
    xml2 = onlineFixture("sales_receipt2.xml")
    sales_receipt = Quickeebooks::Online::Model::SalesReceipt.new
    sales_receipt.header = Quickeebooks::Online::Model::SalesReceiptHeader.new
    sales_receipt.header.note = "Sales receipt for keyboards"
    sales_receipt.header.total_amount = 45.00
    sales_receipt.id = Quickeebooks::Online::Model::Id.new("50")
    sales_receipt.sync_token = 2

    url = "#{@service.url_for_resource(Quickeebooks::Online::Model::SalesReceipt.resource_for_singular)}/#{sales_receipt.id.value}"
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"], :body => xml2)
    updated = @service.update(sales_receipt)
    updated.header.total_amount.should == 50.00
  end

end
