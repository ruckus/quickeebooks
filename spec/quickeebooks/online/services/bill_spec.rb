describe "Quickeebooks::Online::Service::Bill" do
  before(:all) do
    construct_online_service :bill
  end

  it "can fetch a list of bills" do
    xml = onlineFixture("bills.xml")
    url = @service.url_for_resource(Quickeebooks::Online::Model::Bill.resource_for_collection)
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"], :body => xml)
    bills = @service.list
    bills.current_page.should == 1
    bills.entries.count.should == 1
    bills.entries.first.header.balance.should == 25.00
  end

  it "can create a bill" do
    xml = onlineFixture("bill.xml")
    url = @service.url_for_resource(Quickeebooks::Online::Model::Bill.resource_for_singular)
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"], :body => xml)
    bill = Quickeebooks::Online::Model::Bill.new
    bill.header = Quickeebooks::Online::Model::BillHeader.new
    bill.header.total_amount = 25.00
    result = @service.create(bill)
    result.id.value.to_i.should > 0
  end

  it "can delete a bill" do
    url = "#{@service.url_for_resource(Quickeebooks::Online::Model::Bill.resource_for_singular)}/56?methodx=delete"
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"])
    bill = Quickeebooks::Online::Model::Bill.new
    bill.id = Quickeebooks::Online::Model::Id.new("56")
    bill.sync_token = 0
    result = @service.delete(bill)
    result.should == true
  end

  it "can fetch a bill by id" do
    xml = onlineFixture("bill.xml")
    url = "#{@service.url_for_resource(Quickeebooks::Online::Model::Bill.resource_for_singular)}/56"
    FakeWeb.register_uri(:get, url, :status => ["200", "OK"], :body => xml)
    bill = @service.fetch_by_id(56)
    bill.header.total_amount.should == 50
  end

  it "can update a bill" do
    xml2 = onlineFixture("bill2.xml")
    bill = Quickeebooks::Online::Model::Bill.new
    bill.header = Quickeebooks::Online::Model::BillHeader.new
    bill.header.total_amount = 75.00
    bill.id = Quickeebooks::Online::Model::Id.new("56")
    bill.sync_token = 2

    url = "#{@service.url_for_resource(Quickeebooks::Online::Model::Bill.resource_for_singular)}/#{bill.id.value}"
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"], :body => xml2)
    updated = @service.update(bill)
    updated.header.total_amount.should == 75.00
  end

end
