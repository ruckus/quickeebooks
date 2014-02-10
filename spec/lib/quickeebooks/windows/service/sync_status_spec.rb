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

  it "can fetch a single response using sync_status_param query method" do
    xml = windowsFixture("single_sync_status_response.xml")
    model = Quickeebooks::Windows::Model::SyncStatusRequest
    FakeWeb.register_uri(:post, @service.url_for_resource(model::REST_RESOURCE), :status => ["200", "OK"], :body => xml)
    id = 984434
    request = Quickeebooks::Windows::Model::SyncStatusRequest.new(id, 'Payment')
    expect(request.sync_status_param.to_i).to eq id
    expect(request.sync_status_param.object_type).to eq 'Payment'
    sync_status_responses = @service.retrieve(request)

    expect(sync_status_responses.entries.count).to eq 1
    single_response = sync_status_responses.entries.first
    expect(single_response.ng_id_set.to_i).to eq id
  end

  it "can fetch a single response using sync statuses using ng_id_set method" do
    xml = windowsFixture("single_sync_status_response.xml")
    model = Quickeebooks::Windows::Model::SyncStatusRequest
    FakeWeb.register_uri(:post, @service.url_for_resource(model::REST_RESOURCE), :status => ["200", "OK"], :body => xml)
    id = 984434
    request = Quickeebooks::Windows::Model::SyncStatusRequest.new(id, 'Payment', :sync_status => false)
    expect(request.ng_id_set.to_i).to eq id
    expect(request.ng_id_set.ng_object_type).to eq 'Payment'
    sync_status_responses = @service.retrieve(request)

    expect(sync_status_responses.entries.count).to eq 1
    single_response = sync_status_responses.entries.first
    expect(single_response.ng_id_set.to_i).to eq id
  end

end
