describe "Quickeebooks::Online::Service::BillPayment" do
  before(:all) do
    construct_online_service :bill_payment
  end

  describe "list" do
    it "should fetch list of bill payments" do
      xml = onlineFixture "bill_payments.xml"
      url = @service.url_for_resource(Quickeebooks::Online::Model::BillPayment.resource_for_collection)
      FakeWeb.register_uri :post, url, :status => ['200', 'OK'], :body => xml
      bill_payments = @service.list
      bill_payments.count.should == 1
      bill_payments.entries.count.should == 1
      bill_payments.entries[0].id.value.should == '16'
    end
  end

  describe "create" do
    it "should create a bill payment" do
      xml = onlineFixture "bill_payment.xml"
      url = @service.url_for_resource(Quickeebooks::Online::Model::BillPayment.resource_for_singular)
      FakeWeb.register_uri :post, url, :status => ["200", "OK"], :body => xml
      bill_payment = Quickeebooks::Online::Model::BillPayment.new
      bill_payment.header = Quickeebooks::Online::Model::BillPaymentHeader.new
      bill_payment.header.total_amount = 25.00
      result = @service.create bill_payment
      result.id.value.to_i.should > 0
    end
  end

  describe "delete" do
    it "should delete a bill payment" do
      url = "#{@service.url_for_resource(Quickeebooks::Online::Model::BillPayment.resource_for_singular)}/56?methodx=delete"
      FakeWeb.register_uri :post, url, :status => ["200", "OK"]
      bill_payment = Quickeebooks::Online::Model::BillPayment.new
      bill_payment.id = Quickeebooks::Online::Model::Id.new("56")
      bill_payment.sync_token = 0
      result = @service.delete bill_payment
      result.should == true
    end
  end

  describe "fetch_by_id" do
    it "should retrive bill payment by id" do
      xml = onlineFixture("bill_payment.xml")
      url = "#{@service.url_for_resource(Quickeebooks::Online::Model::BillPayment.resource_for_singular)}/56"
      FakeWeb.register_uri :get, url, :status => ["200", "OK"], :body => xml
      bill_payment = @service.fetch_by_id(56)
      bill_payment.header.total_amount.should == 5000
    end
  end

  describe "update" do
    it "should update existing bill payment" do
      xml2 = onlineFixture("bill_payment2.xml")
      bill_payment = Quickeebooks::Online::Model::BillPayment.new
      bill_payment.header = Quickeebooks::Online::Model::BillPaymentHeader.new
      bill_payment.header.total_amount = 75.00
      bill_payment.id = Quickeebooks::Online::Model::Id.new("56")
      bill_payment.sync_token = 2

      url = "#{@service.url_for_resource(Quickeebooks::Online::Model::BillPayment.resource_for_singular)}/#{bill_payment.id.value}"

      FakeWeb.register_uri :post, url, :status => ["200", "OK"], :body => xml2
      updated = @service.update(bill_payment)
      updated.header.total_amount.should == 75.00
    end
  end
end
