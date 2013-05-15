describe "Quickeebooks::Windows::Service::SyncActivity" do
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

  it "can fetch a list of time_activities" do
    xml = windowsFixture("sync_activity_responses.xml")
    model = Quickeebooks::Windows::Model::SyncActivityResponse
    service = Quickeebooks::Windows::Service::SyncActivity.new
    service.access_token = @oauth
    service.realm_id = @realm_id
    FakeWeb.register_uri(:post, service.url_for_resource(model::REST_RESOURCE), :status => ["200", "OK"], :body => xml)
    sync_activity_responses = service.retrieve
    sync_activity_responses.entries.count.should == 1
    single_response = sync_activity_responses.entries.first
    single_response.sync_type.should == "Writeback"
    single_response.start_sync_tms.should == Time.parse("2011-07-29 07:09:02 -0400")
    single_response.end_sync_tms.should == Time.parse("2011-07-29 07:09:02 -0400")
    single_response.entity_name.should == "Customer"
    drill_down = single_response.sync_status_drill_down
    drill_down.sync_tms.should == Time.parse("2011-07-29 14:09:02 UTC")
    drill_down.entity_id.should == "2480872"
    drill_down.request_id.should == "0729e1124a274fc79d65a1d97233877f"
    drill_down.ng_object_type.should == "Customer"
    drill_down.operation_type.should == "CustomerAdd"
    drill_down.sync_message_code.should == "10"
    drill_down.sync_message.should == "success"
  end

end
