describe "Quickeebooks::Windows::Service::CompanyMetaData" do
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

  it "can fetch the company meta data" do
    xml = windowsFixture("company_meta_data.xml")
    model = Quickeebooks::Windows::Model::CompanyMetaData
    service = Quickeebooks::Windows::Service::CompanyMetaData.new
    service.access_token = @oauth
    service.realm_id = @realm_id
    FakeWeb.register_uri(:get, service.url_for_resource(model::REST_RESOURCE), :status => ["200", "OK"], :body => xml)
    company_meta_data_response = service.load

    company_meta_data_response.registered_company_name.should == "Castle Rock Construction"
  end
end
