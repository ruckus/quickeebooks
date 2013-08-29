describe "Quickeebooks::Windows::Service::SyncStatus" do
  before(:all) do
    construct_windows_service :sync_status
  end

  it "can fetch a list of sync statuses" do
    xml = windowsFixture("sync_status_responses.xml")
    model = Quickeebooks::Windows::Model::SyncStatusRequest
    FakeWeb.register_uri(:post, @service.url_for_resource(model::REST_RESOURCE), :status => ["200", "OK"], :body => xml)

    request = Quickeebooks::Windows::Model::SyncStatusRequest.new
    sync_status_responses = @service.retrieve(request)

    sync_status_responses.entries.count.should == 15
    single_response = sync_status_responses.entries.first
    single_response.ng_id_set.to_i.should == 145058
    single_response.state_desc.should == "Next Gen record created"
  end

end
