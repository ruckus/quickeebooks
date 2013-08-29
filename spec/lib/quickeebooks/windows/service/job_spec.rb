describe "Quickeebooks::Windows::Service::Job" do
  before(:all) do
    construct_windows_service :job
  end

  it "can fetch a list of jobs" do
    xml = windowsFixture("jobs.xml")
    model = Quickeebooks::Windows::Model::Job
    FakeWeb.register_uri(:post, @service.url_for_resource(model::REST_RESOURCE), :status => ["200", "OK"], :body => xml)
    jobs = @service.list
    jobs.entries.count.should == 1
    my_job = jobs.entries.first
    my_job.name.should == "My Job Name"

    my_job_address = my_job.billing_address
    my_job_address.should_not == nil
    my_job_address.line1.should == "EngeniusMicro"
    my_job_address.line2.should == "107 Jefferson Street N"
    my_job_address.city.should == "Huntsville"
    my_job_address.state.should == "AL"
    my_job_address.postal_code.should == "35801"

    my_job.email.address.should == "michael.whitley@engeniusmicro.com"
    my_job.dba_name.should == "EngeniusMicro"
    my_job.acct_num.should == ".0000"
    my_job.job_parent_name.should == ".0000.001"
  end

  it "gets a REST error when filters are not in expected order" do
    xml = windowsFixture("job_list_error_invalid_filter_ordering.xml")
    model = Quickeebooks::Windows::Model::Job
    FakeWeb.register_uri(:post, @service.url_for_resource(model::REST_RESOURCE), :status => ["200", "OK"], :body => xml)


    filters = []
    filters << Quickeebooks::Windows::Service::Filter.new(:datetime, :field => 'StartCreatedTMS', :value => Time.mktime(2013, 6, 1))
    filters << Quickeebooks::Windows::Service::Filter.new(:datetime, :field => 'EndCreatedTMS', :value => Time.mktime(2013, 6, 10))

    expect { response = @service.list(filters) }.to raise_error(IntuitRequestException)
  end

  it "reorders filters according to the Service specification" do

    f1 = Quickeebooks::Windows::Service::Filter.new(:datetime, :field => 'StartCreatedTMS', :value => Time.mktime(2013, 6, 1))
    f2 = Quickeebooks::Windows::Service::Filter.new(:boolean, :field => 'CustomFieldEnable', :value => true)
    f3 = Quickeebooks::Windows::Service::Filter.new(:datetime, :field => 'EndCreatedTMS', :value => Time.mktime(2013, 6, 10))

    out_of_order = [f1, f2, f3]
    in_order = [f2, f1, f3]
    reordered = @service.enforce_filter_order(out_of_order)

    reordered.should == in_order
  end

end
