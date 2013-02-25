describe "Quickeebooks::Windows::Service::ShipMethod" do
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

  it "can fetch a list of shipping methods" do
    xml = windowsFixture("ship_methods.xml")
    model = Quickeebooks::Windows::Model::ShipMethod
    service = Quickeebooks::Windows::Service::ShipMethod.new
    service.access_token = @oauth
    service.realm_id = @realm_id
    FakeWeb.register_uri(:post, service.url_for_resource(model::REST_RESOURCE), :status => ["200", "OK"], :body => xml)
    shipping_methods = service.list
    shipping_methods.entries.count.should == 15

    vinlux = shipping_methods.entries.detect { |sm| sm.name == "Vinlux" }
    vinlux.should_not == nil
    vinlux.id.value.should == "13"
  end

end