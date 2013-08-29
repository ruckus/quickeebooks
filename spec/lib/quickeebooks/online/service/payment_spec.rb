describe "Quickeebooks::Online::Service::Payment" do
  before(:all) do
    construct_online_service :payment
  end

  it "can fetch a list of payments" do
    xml = onlineFixture("payments.xml")
    url = @service.url_for_resource(Quickeebooks::Online::Model::Payment.resource_for_collection)
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"], :body => xml)
    payments = @service.list
    payments.current_page.should == 1
    payments.entries.count.should == 1
    payments.entries.first.header.total_amount.should == 50.00
  end

  it "can create a payment" do
    xml = onlineFixture("payment.xml")
    url = @service.url_for_resource(Quickeebooks::Online::Model::Payment.resource_for_singular)
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"], :body => xml)
    payment = Quickeebooks::Online::Model::Payment.new
    payment.header = Quickeebooks::Online::Model::PaymentHeader.new
    payment.header.note = "Payment against Invoice"
    payment.header.total_amount = 20.00
    result = @service.create(payment)
    result.id.value.to_i.should > 0
  end

  it "can delete a payment" do
    url = "#{@service.url_for_resource(Quickeebooks::Online::Model::Payment.resource_for_singular)}/5?methodx=delete"
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"])
    payment = Quickeebooks::Online::Model::Payment.new
    payment.id = Quickeebooks::Online::Model::Id.new("5")
    payment.sync_token = 0
    result = @service.delete(payment)
    result.should == true
  end

  it "can fetch a payment by id" do
    xml = onlineFixture("payment.xml")
    url = "#{@service.url_for_resource(Quickeebooks::Online::Model::Payment.resource_for_singular)}/47"
    FakeWeb.register_uri(:get, url, :status => ["200", "OK"], :body => xml)
    payment = @service.fetch_by_id(47)
    payment.header.total_amount.should == 20.00
  end

  it "can update a payment" do
    xml2 = onlineFixture("payment2.xml")
    payment = Quickeebooks::Online::Model::Payment.new
    payment.header = Quickeebooks::Online::Model::PaymentHeader.new
    payment.header.note = "Payment against Invoice"
    payment.header.total_amount = 50.00
    payment.id = Quickeebooks::Online::Model::Id.new("50")
    payment.sync_token = 2

    url = "#{@service.url_for_resource(Quickeebooks::Online::Model::Payment.resource_for_singular)}/#{payment.id.value}"
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"], :body => xml2)
    updated = @service.update(payment)
    updated.header.total_amount.should == 50.00
  end

end
