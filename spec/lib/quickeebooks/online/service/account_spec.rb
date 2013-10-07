describe "Quickeebooks::Online::Service::Account" do
  before(:all) do
    construct_online_service :account
  end

  it "receives 404 from invalid base URL" do
    uri = "https://qbo.intuit.com/invalid"
    url = @service.url_for_resource(Quickeebooks::Online::Model::Account.resource_for_collection)
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"], :body => "blah")
    lambda { @service.list }.should raise_error(IntuitRequestException)
  end

  it "can fetch a list of accounts" do
    xml = onlineFixture("accounts.xml")
    url = @service.url_for_resource(Quickeebooks::Online::Model::Account.resource_for_collection)
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"], :body => xml)
    accounts = @service.list
    accounts.current_page.should == 1
    accounts.entries.count.should == 10
    accounts.entries.first.current_balance.should == 6200
  end

  it "can create an account" do
    xml = onlineFixture("account.xml")
    url = @service.url_for_resource(Quickeebooks::Online::Model::Account.resource_for_singular)
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"], :body => xml)
    account = Quickeebooks::Online::Model::Account.new
    account.name = "Billy Bob"
    account.sub_type = "AccountsPayable"
    account.valid?.should == true
    result = @service.create(account)
    result.id.to_i.should > 0
  end

  it "can delete an account" do
    url = @service.url_for_resource(Quickeebooks::Online::Model::Account.resource_for_singular)
    url = "#{url}/99?methodx=delete"
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"])
    account = Quickeebooks::Online::Model::Account.new
    account.id = Quickeebooks::Online::Model::Id.new(99)
    account.sync_token = 0
    result = @service.delete(account)
    result.should == true
  end

  it "cannot delete an account with missing required fields for deletion" do
    account = Quickeebooks::Online::Model::Account.new
    lambda { @service.delete(account) }.should raise_error(InvalidModelException, "Missing required parameters for delete")
  end

  it "exception is raised when we try to create an invalid account" do
    account = Quickeebooks::Online::Model::Account.new
    lambda { @service.create(account) }.should raise_error(InvalidModelException)
  end

  it "can fetch an account by id" do
    xml = onlineFixture("account.xml")
    url = @service.url_for_resource(Quickeebooks::Online::Model::Account.resource_for_singular)
    url = "#{url}/99"
    FakeWeb.register_uri(:get, url, :status => ["200", "OK"], :body => xml)
    account = @service.fetch_by_id(99)
    account.name.should == "Billy Bob"
  end

end
