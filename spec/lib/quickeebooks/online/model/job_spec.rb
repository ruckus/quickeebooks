describe "Quickeebooks::Online::Model::Job" do

  it "parse job from XML" do
    xml = onlineFixture("job_create_response.xml")
    job = Quickeebooks::Online::Model::Job.from_xml(xml)
    job.sync_token.should == 0
    job.name.should == "Kitchen Cleaning"
    job.customer_name.should == "Acme Wines"
  end

  it "can assign a web site" do
    job = Quickeebooks::Online::Model::Job.new
    the_uri = "http://example.org"
    job.web_site = Quickeebooks::Online::Model::WebSite.new(the_uri)
    job.web_site.is_a?(Quickeebooks::Online::Model::WebSite).should == true
    job.web_site.uri.should == the_uri
  end
  
  it "must require a Customer ID for Create" do
    job = Quickeebooks::Online::Model::Job.new
    job.name = "Computer Repair"
    job.valid?.should == false
    error = job.errors.messages[:customer_id]
    error.should_not == nil
    error[0].should == 'Must provide a Customer ID.'
  end

end
