describe "Quickeebooks::Windows::Service::Job" do
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

  it "can fetch a list of jobs" do
    xml = windowsFixture("jobs.xml")
    model = Quickeebooks::Windows::Model::Job
    service = Quickeebooks::Windows::Service::Job.new
    service.access_token = @oauth
    service.realm_id = @realm_id
    FakeWeb.register_uri(:post, service.url_for_resource(model::REST_RESOURCE), :status => ["200", "OK"], :body => xml)
    jobs = service.list
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

end