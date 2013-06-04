describe "Quickeebooks::Windows::Service::SyncStatus" do
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

  it "can fetch a list of sync statuses" do
    xml = windowsFixture("sync_status_responses.xml")
    model = Quickeebooks::Windows::Model::SyncStatusRequest
    service = Quickeebooks::Windows::Service::SyncStatus.new
    service.access_token = @oauth
    service.realm_id = @realm_id
    FakeWeb.register_uri(:post, service.url_for_resource(model::REST_RESOURCE), :status => ["200", "OK"], :body => xml)
    
    request = Quickeebooks::Windows::Model::SyncStatusRequest.new
    sync_status_responses = service.retrieve(request)

    sync_status_responses.entries.count.should == 15
    single_response = sync_status_responses.entries.first
    single_response.ng_id_set.to_i.should == 145058
    single_response.state_desc.should == "Next Gen record created"
  end

end
