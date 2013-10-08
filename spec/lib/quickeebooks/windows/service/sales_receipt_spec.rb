describe "Quickeebooks::Windows::Service::SalesReceipt" do
  before(:all) do
    construct_windows_service :sales_receipt
  end

  it "can fetch a sales receipt by ID" do
    xml = windowsFixture("fetch_sales_receipt_by_id.xml")
    model = Quickeebooks::Windows::Model::SalesReceipt
    FakeWeb.register_uri(:get, "#{@service.url_for_resource(model::REST_RESOURCE)}/341?idDomain=QB", :status => ["200", "OK"], :body => xml)
    sales_receipt = @service.fetch_by_id(341)
    sales_receipt.line_items.count.should eql 2
    sales_receipt.line_items.first.unit_price.should eql 1250.0
    sales_receipt.line_items.first.desc.should eql "QWERTY Keyboards"
  end

end