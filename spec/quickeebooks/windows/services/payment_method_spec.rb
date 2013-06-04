describe "Quickeebooks::Windows::Service::PaymentMethod" do
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

  it "can fetch a list of payment methods" do
    xml = windowsFixture("payment_methods.xml")
    service = Quickeebooks::Windows::Service::PaymentMethod.new
    service.access_token = @oauth
    service.realm_id = @realm_id

    model = Quickeebooks::Windows::Model::PaymentMethod
    FakeWeb.register_uri(:post,
                         service.url_for_resource(model::REST_RESOURCE),
                         :status => ["200", "OK"],
                         :body => xml)
    methods = service.list
    methods.entries.count.should == 9

    method1 = methods.entries.first
    method1.id.value.should == "9"
    method1.name.should == "E-Check"
  end
end
