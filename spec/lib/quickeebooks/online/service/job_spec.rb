describe "Quickeebooks::Online::Service::Job" do
  before(:all) do
    construct_online_service :job
  end

  it "can fetch a list of jobs" do
    xml = onlineFixture("jobs.xml")
    url = @service.url_for_resource(Quickeebooks::Online::Model::Job.resource_for_collection)
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"], :body => xml)
    jobs = @service.list
    jobs.current_page.should == 1
    jobs.entries.count.should == 1
    jobs.entries.first.name.should == "Kitchen Cleaning"
  end

  it "can create a job" do
    xml = onlineFixture("job_create_response.xml")
    url = @service.url_for_resource(Quickeebooks::Online::Model::Job.resource_for_singular)
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"], :body => xml)

    job = Quickeebooks::Online::Model::Job.new
    job.customer_id = Quickeebooks::Online::Model::Id.new(128)
    job.name = "Computer Repair"
    result = @service.create(job)
    result.id.value.to_i.should > 0
  end

  it "can delete a job" do
    url = "#{@service.url_for_resource(Quickeebooks::Online::Model::Job.resource_for_singular)}/99?methodx=delete"
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"])
    job = Quickeebooks::Online::Model::Job.new
    job.id = Quickeebooks::Online::Model::Id.new("99")
    job.sync_token = 0
    result = @service.delete(job)
    result.should == true
  end

  it "can fetch a job by id" do
    xml = onlineFixture("job_create_response.xml")
    url = "#{@service.url_for_resource(Quickeebooks::Online::Model::Job.resource_for_singular)}/128"
    FakeWeb.register_uri(:get, url, :status => ["200", "OK"], :body => xml)
    job = @service.fetch_by_id(128)
    job.name.should == "Kitchen Cleaning"
  end
   
  it "can update a job" do
    xml2 = onlineFixture("job_create_response.xml")
    job = Quickeebooks::Online::Model::Job.new
    job.name = "Computer Repair"
    job.customer_id = Quickeebooks::Online::Model::Id.new("10")
    job.id = Quickeebooks::Online::Model::Id.new("128")
    job.sync_token = 2
  
    url = "#{@service.url_for_resource(Quickeebooks::Online::Model::Job.resource_for_singular)}/#{job.id.value}"
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"], :body => xml2)
    updated = @service.update(job)
    updated.name.should == "Kitchen Cleaning"
  end
end
