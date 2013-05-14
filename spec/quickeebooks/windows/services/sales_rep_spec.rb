describe "Quickeebooks::Windows::Service::SalesRep" do
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

  it "can fetch a list of sales reps" do
    xml = windowsFixture("sales_reps.xml")
    service = Quickeebooks::Windows::Service::SalesRep.new
    service.access_token = @oauth
    service.realm_id = @realm_id

    model = Quickeebooks::Windows::Model::SalesRep
    FakeWeb.register_uri(:post, service.url_for_resource(model::REST_RESOURCE), :status => ["200", "OK"], :body => xml)
    reps = service.list
    reps.entries.count.should == 10

    lukas = reps.entries.detect { |sr| sr.id.value == "13" }
    lukas.should_not == nil
    lukas.external_key.value.should == "13"
    lukas.initials.should == "LB"
    lukas.vendor.vendor_id.value.should == "275"
    lukas.vendor.vendor_name.should == "Lukas Billybob"

    other_name = reps.entries.detect { |r| r.other_name? }
    other_name.should_not == nil
    other_name.other_name.other_name_id.value.should == "96"
    other_name.other_name.other_name_name.should == "Samples."
  end

end