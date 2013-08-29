describe "Quickeebooks::Online::Service::TimeActivity" do
  before(:all) do
    construct_online_service :time_activity
  end

  it "can fetch a list of time activities" do
    xml = onlineFixture("time_activities.xml")
    url = @service.url_for_resource(Quickeebooks::Online::Model::TimeActivity.resource_for_collection)
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"], :body => xml)
    time_activities = @service.list
    time_activities.current_page.should == 1
    time_activities.entries.count.should == 1
    time_activities.entries.first.vendor.vendor_id.value.should == "3793"
  end

  it "can create a time activity" do
    xml = onlineFixture("time_activity.xml")
    url = @service.url_for_resource(Quickeebooks::Online::Model::TimeActivity.resource_for_singular)
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"], :body => xml)
    time_activity = Quickeebooks::Online::Model::TimeActivity.new
    time_activity.description = "here is my description"
    time_activity.hourly_rate = "10.5"
    time_activity.name_of = "Vendor"
    time_activity.hours = 10
    time_activity.customer_id = "3794"
    time_activity.minutes = 5
    result = @service.create(time_activity)
    result.id.value.to_i.should > 0
    result.vendor.is_a?(Quickeebooks::Online::Model::TimeActivityVendor)
  end

  it "can delete a time_activity" do
    url = "#{@service.url_for_resource(Quickeebooks::Online::Model::TimeActivity.resource_for_singular)}/11?methodx=delete"
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"])
    time_activity = Quickeebooks::Online::Model::TimeActivity.new
    time_activity.id = Quickeebooks::Online::Model::Id.new("11")
    time_activity.sync_token = 0
    result = @service.delete(time_activity)
    result.should == true
  end

  it "cannot delete a time_activity with missing required fields for deletion" do
    time_activity = Quickeebooks::Online::Model::TimeActivity.new
    expect { @service.delete(time_activity) }.to raise_exception(InvalidModelException, "Missing required parameters for delete")
  end

  it "exception is raised when we try to create an invalid time_activity" do
    time_activity = Quickeebooks::Online::Model::TimeActivity.new
    expect { @service.create(time_activity) }.to raise_exception InvalidModelException
  end

  it "cannot update an invalid time_activity" do
    time_activity = Quickeebooks::Online::Model::TimeActivity.new
    time_activity.name = "John Bilby"
    expect { @service.update(time_activity) }.to raise_exception InvalidModelException
  end

  it "can fetch a time_activity by id" do
    xml = onlineFixture("time_activity.xml")
    url = "#{@service.url_for_resource(Quickeebooks::Online::Model::TimeActivity.resource_for_singular)}/11"
    FakeWeb.register_uri(:get, url, :status => ["200", "OK"], :body => xml)
    time_activity = @service.fetch_by_id(11)
    time_activity.vendor.vendor_id.value.should == "3793"
  end

  it "can update a time_activity" do
    xml2 = onlineFixture("time_activity2.xml")
    time_activity = Quickeebooks::Online::Model::TimeActivity.new
    time_activity.id = Quickeebooks::Online::Model::Id.new("1")
    time_activity.sync_token = 2

    url = "#{@service.url_for_resource(Quickeebooks::Online::Model::TimeActivity.resource_for_singular)}/#{time_activity.id.value}"
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"], :body => xml2)
    updated = @service.update(time_activity)
    updated.hours.should == 12
    updated.minutes.should == 15
  end

  it 'Can update a fetched time_activity' do
    xml = onlineFixture("time_activity.xml")
    url = "#{@service.url_for_resource(Quickeebooks::Online::Model::TimeActivity.resource_for_singular)}/11"
    FakeWeb.register_uri(:get, url, :status => ["200", "OK"], :body => xml)
    time_activity = @service.fetch_by_id(11)
    url = "#{@service.url_for_resource(Quickeebooks::Online::Model::TimeActivity.resource_for_singular)}/#{time_activity.id.value}"
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"], :body => xml)
    updated = @service.update(time_activity)
  end

end
