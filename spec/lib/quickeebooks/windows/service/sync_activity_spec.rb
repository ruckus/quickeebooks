describe "Quickeebooks::Windows::Service::SyncActivity" do
  before(:all) do
    construct_windows_service :sync_activity
  end

  it "can fetch a list of time_activities" do
    xml = windowsFixture("sync_activity_responses.xml")
    model = Quickeebooks::Windows::Model::SyncActivityResponse
    FakeWeb.register_uri(:post, @service.url_for_resource(model::REST_RESOURCE), :status => ["200", "OK"], :body => xml)
    sync_activity_responses = @service.retrieve
    sync_activity_responses.entries.count.should == 1
    single_response = sync_activity_responses.entries.first
    single_response.sync_type.should == "Writeback"
    single_response.start_sync_tms.utc.should == Time.parse("2011-07-29T07:09:02.0").utc
    single_response.end_sync_tms.utc.should == Time.parse("2011-07-29T07:09:02.0").utc
    single_response.entity_name.should == "Customer"
    drill_down = single_response.sync_status_drill_down
    drill_down.sync_tms.should == Time.parse("2011-07-29T14:09:02.0Z").utc
    drill_down.entity_id.should == "2480872"
    drill_down.request_id.should == "0729e1124a274fc79d65a1d97233877f"
    drill_down.ng_object_type.should == "Customer"
    drill_down.operation_type.should == "CustomerAdd"
    drill_down.sync_message_code.should == "10"
    drill_down.sync_message.should == "success"
  end

end
