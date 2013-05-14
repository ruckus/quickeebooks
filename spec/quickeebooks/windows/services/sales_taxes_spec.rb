describe "Quickeebooks::Windows::Service::SalesTax" do
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

  it "can fetch a list of sales taxes" do
    xml = windowsFixture("sales_taxes.xml")
    model = Quickeebooks::Windows::Model::SalesTax
    service = Quickeebooks::Windows::Service::SalesTax.new
    service.access_token = @oauth
    service.realm_id = @realm_id
    FakeWeb.register_uri(:post, service.url_for_resource(model::REST_RESOURCE), :status => ["200", "OK"], :body => xml)
    shipping_methods = service.list
    shipping_methods.entries.count.should == 2

    sf = shipping_methods.entries.detect { |sm| sm.name == "San Francisco County" }
    sf.should_not == nil
    sf.id.value.should == "80"
    sf.desc.should == 'Sales Tax - San Francisco'
    sf.tax_rate.should == 8.5

  end

end