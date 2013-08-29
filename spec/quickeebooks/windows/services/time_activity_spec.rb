describe "Quickeebooks::Windows::Service::TimeActivity" do
  before(:all) do
    construct_windows_service :time_activity
  end

  it "can fetch a list of time_activities" do
    xml = windowsFixture("time_activities.xml")
    model = Quickeebooks::Windows::Model::TimeActivity
    FakeWeb.register_uri(:post, @service.url_for_resource(model::REST_RESOURCE), :status => ["200", "OK"], :body => xml)
    time_activities = @service.list
    time_activities.entries.count.should == 1
    my_time = time_activities.entries.first
    my_time.billable_status.should == "NotBillable"
    my_time.customer_name.should == "ADMN.3.0001"
    my_time.pay_item_name.should == "BP Labor"
    my_time.hours.should == "4"
    my_time.minutes.should == "0"
    my_time.txn_date.should == "2012-03-20"
    my_time.employee.employee_name.should == "Whitley, Michael"
    my_time.employee.employee_id.value.should == "246"
  end

  it "cannot create a time activity if invalid" do
    time_activity = Quickeebooks::Windows::Model::TimeActivity.new
    lambda do
      @service.create(time_activity)
    end.should raise_error(InvalidModelException)

    time_activity.valid?.should == false
    time_activity.errors.keys.should include(:name_of)
  end

  it "can create a time_activity" do
    xml = windowsFixture("time_activity_create_success.xml")
    model = Quickeebooks::Windows::Model::TimeActivity
    time_activity = Quickeebooks::Windows::Model::TimeActivity.new

    FakeWeb.register_uri(:post, @service.url_for_resource(model::REST_RESOURCE), :status => ["200", "OK"], :body => xml)

    time_activity.name_of = 'Employee'
    employee = Quickeebooks::Windows::Model::TimeActivityEmployee.new
    employee.employee_name = 'Bugs Bunny'
    time_activity.employee = employee
    time_activity.start_time = "2013-08-14T18:45:00Z"
    time_activity.end_time = "2013-08-14T19:15:22Z"
    time_activity.txn_date = "2013-08-14"
    time_activity.hours = 0
    time_activity.minutes = 30
    time_activity.seconds = 0

    create_response = @service.create(time_activity)
    create_response.success?.should == true
    create_response.success.object_ref.id.value.should == "517536"
    create_response.success.request_name.should == "TimeActivityAdd"
  end

end
