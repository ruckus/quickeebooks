describe "Quickeebooks::Windows::Service::Item" do
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

  it "can fetch a list of Items" do
    xml = windowsFixture("items.xml")
    model = Quickeebooks::Windows::Model::Item
    service = Quickeebooks::Windows::Service::Item.new
    service.access_token = @oauth
    service.realm_id = @realm_id
    FakeWeb.register_uri(:post, service.url_for_resource(model::REST_RESOURCE), :status => ["200", "OK"], :body => xml)
    items = service.list
    items.entries.count.should == 2
    gruner = items.entries.first
    gruner.name.should == "FGVS09"

  end

  it "can fetch an Item by ID" do
    xml = windowsFixture("item.xml")
    model = Quickeebooks::Windows::Model::Item
    service = Quickeebooks::Windows::Service::Item.new
    service.access_token = @oauth
    service.realm_id = @realm_id
    FakeWeb.register_uri(:get, "#{service.url_for_resource(model::REST_RESOURCE)}/407?idDomain=QB", :status => ["200", "OK"], :body => xml)
    customer = service.fetch_by_id(407)
    customer.name.should == "DWCSH11"
  end

end