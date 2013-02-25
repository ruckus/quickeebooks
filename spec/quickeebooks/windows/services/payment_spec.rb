describe "Quickeebooks::Windows::Service::Payment" do
  before(:all) do
    FakeWeb.allow_net_connect = false
    qb_key = "key"
    qb_secret = "secreet"

    @realm_id = "9991111222"
    @base_uri = "https://qbo.intuit.com/qbo36"
    @oauth_consumer = OAuth::Consumer.new(qb_key, qb_key, {
        :site                 => "https://oauth.intuit.com",
        :request_token_path   => "/oauth/v1/get_request_token",
        :authorize_path       => "/oauth/v1/get_access_token",
        :access_token_path    => "/oauth/v1/get_access_token"
    })
    @oauth = OAuth::AccessToken.new(@oauth_consumer, "blah", "blah")
  end

  it "can fetch a list of payments" do
    xml = windowsFixture("payments.xml")
    service = Quickeebooks::Windows::Service::Payment.new
    service.access_token = @oauth
    service.realm_id = @realm_id

    model = Quickeebooks::Windows::Model::Payment
    FakeWeb.register_uri(:post,
                         service.url_for_resource(model::REST_RESOURCE),
                         :status => ["200", "OK"],
                         :body => xml)
    payments = service.list
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
end
