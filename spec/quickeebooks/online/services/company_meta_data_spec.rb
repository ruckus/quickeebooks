describe "Quickeebooks::Online::Service::CompanyMetaData" do
  before(:all) do
    FakeWeb.allow_net_connect = false
    qb_key = "key"
    qb_secret = "secreet"

    @realm_id = "9991111222"
    @oauth_consumer = OAuth::Consumer.new(qb_key, qb_key, {
        :site                 => "https://oauth.intuit.com",
        :request_token_path   => "/oauth/v1/get_request_token",
        :authorize_path       => "/oauth/v1/get_access_token",
        :access_token_path    => "/oauth/v1/get_access_token"
    })
    @oauth = OAuth::AccessToken.new(@oauth_consumer, "blah", "blah")

    @service = Quickeebooks::Online::Service::CompanyMetaData.new
    @service.access_token = @oauth
    @service.instance_eval {
      @realm_id = "9991111222"
    }
  end

  it "can get the realm's company_meta_data record" do
    xml = onlineFixture("company_meta_data.xml")
    url = @service.url_for_resource(Quickeebooks::Online::Model::CompanyMetaData.resource_for_singular)
    FakeWeb.register_uri(:get, url, :status => ["200", "OK"], :body => xml)
    company_meta_data_response = @service.load
    company_meta_data_response.registered_company_name.should == "Bay Area landscape services"
  end
end
