describe "Quickeebooks::Online::Service::Clazz" do
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
    
    @service = Quickeebooks::Online::Service::Clazz.new
    @service.access_token = @oauth
    @service.instance_eval {
      @realm_id = "9991111222"
    }
  end

  it "can fetch a list of classes" do
    xml = onlineFixture("classes.xml")
    model = Quickeebooks::Online::Model::Clazz
    url = @service.url_for_resource(Quickeebooks::Online::Model::Clazz.resource_for_collection)
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"], :body => xml)
    classes = @service.list
    classes.entries.count.should == 1
    entry = classes.entries.first
    entry.name.should == "FOO"
    entry.id.to_s.should == '3550000000000079157695'
  end
  
  it "can create a Class" do
    xml = onlineFixture("class.xml")
    url = @service.url_for_resource(Quickeebooks::Online::Model::Clazz.resource_for_singular)
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"], :body => xml)
    clazz = Quickeebooks::Online::Model::Clazz.new
    clazz.name = "TEST CLASS"
    clazz.valid?.should == true
    result = @service.create(clazz)
    result.id.to_s.should == "3600000000000725718"
  end

  it "can delete an account" do
    url = @service.url_for_resource(Quickeebooks::Online::Model::Clazz.resource_for_singular)
    url = "#{url}/3600000000000725718?methodx=delete"
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"])
    clazz = Quickeebooks::Online::Model::Clazz.new
    clazz.id = Quickeebooks::Online::Model::Id.new('3600000000000725718')
    clazz.sync_token = 0
    result = @service.delete(clazz)
    result.should == true
  end
  
  it "cannot delete an account with missing required fields for deletion" do
    clazz = Quickeebooks::Online::Model::Clazz.new
    lambda { @service.delete(clazz) }.should raise_error(InvalidModelException, "Missing required parameters for delete")
  end
  
  it "exception is raised when we try to create an invalid account" do
    clazz = Quickeebooks::Online::Model::Clazz.new
    lambda { @service.create(clazz) }.should raise_error(InvalidModelException)
  end
 
  it "can fetch an account by id" do
    xml = onlineFixture("class.xml")
    url = @service.url_for_resource(Quickeebooks::Online::Model::Clazz.resource_for_singular)
    url = "#{url}/3600000000000725718"
    FakeWeb.register_uri(:get, url, :status => ["200", "OK"], :body => xml)
    clazz = @service.fetch_by_id('3600000000000725718')
    clazz.name.should == "TEST CLASS"
  end

end