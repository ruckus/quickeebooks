describe "Quickeebooks::Windows::Service::Payment" do
  before(:all) do
    construct_windows_service :payment
  end

  it "can fetch a list of payments" do
    xml = windowsFixture("payments.xml")

    model = Quickeebooks::Windows::Model::Payment
    FakeWeb.register_uri(:post,
                         @service.url_for_resource(model::REST_RESOURCE),
                         :status => ["200", "OK"],
                         :body => xml)
    payments = @service.list
    payments.entries.count.should == 1

    payment = payments.entries.first
    payment.id.value.should == "4"
    payment.header.should_not be_nil
    header = payment.header
    header.customer_name.should == "Davis"

    line1 = payment.line_items.first
    line1.should_not be_nil
    line1.amount.should == header.total_amount
  end

  it "can create a payment" do
    xml = windowsFixture("payment_create_success.xml")
    model = Quickeebooks::Windows::Model::Payment
    customer = Quickeebooks::Windows::Model::Payment.new

    FakeWeb.register_uri(:post, @service.url_for_resource(model::REST_RESOURCE), :status => ["200", "OK"], :body => xml)

    payment = Quickeebooks::Windows::Model::Payment.new
    payment.header = Quickeebooks::Windows::Model::PaymentHeader.new
    payment.header.customer_id = Quickeebooks::Windows::Model::Id.new("4")
    payment.header.payment_method_id = Quickeebooks::Windows::Model::Id.new("8") # Gift Card

    payment.header.doc_number = "99999"
    payment.header.txn_date = Date.civil(2013, 5, 3)
    payment.header.total_amount = 88

    line_item = Quickeebooks::Windows::Model::PaymentLineItem.new
    line_item.desc = "Dog Grooming"
    line_item.amount = 88
    payment.line_items << line_item

    create_response = @service.create(payment)
    create_response.success?.should == true
    create_response.success.object_ref.id.value.should == "984434"
    create_response.success.request_name.should == "PaymentAdd"
  end
end
