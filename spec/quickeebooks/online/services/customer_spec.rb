describe "Quickeebooks::Online::Service::Customer" do
  before(:all) do
    construct_online_service :customer
  end

  it "can fetch a list of customers" do
    xml = onlineFixture("customers.xml")
    url = @service.url_for_resource(Quickeebooks::Online::Model::Customer.resource_for_collection)
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"], :body => xml)
    accounts = @service.list
    accounts.current_page.should == 1
    accounts.entries.count.should == 3
    accounts.entries.first.name.should == "John Doe"
  end

  it "can fetch a list of customers with filters" do
    xml = onlineFixture("customers.xml")
    url = @service.url_for_resource(Quickeebooks::Online::Model::Customer.resource_for_collection)
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"], :body => xml)
    accounts = @service.list
    accounts.current_page.should == 1
    accounts.entries.count.should == 3
    accounts.entries.first.name.should == "John Doe"
  end

  it "can create a customer" do
    xml = onlineFixture("customer.xml")
    url = @service.url_for_resource(Quickeebooks::Online::Model::Customer.resource_for_singular)
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"], :body => xml)
    customer = Quickeebooks::Online::Model::Customer.new
    customer.name = "Billy Bob"
    result = @service.create(customer)
    result.id.value.to_i.should > 0
  end

  it "can delete a customer" do
    url = "#{@service.url_for_resource(Quickeebooks::Online::Model::Customer.resource_for_singular)}/99?methodx=delete"
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"])
    customer = Quickeebooks::Online::Model::Customer.new
    customer.id = Quickeebooks::Online::Model::Id.new("99")
    customer.sync_token = 0
    result = @service.delete(customer)
    result.should == true
  end

  it "cannot delete a customer with missing required fields for deletion" do
    customer = Quickeebooks::Online::Model::Customer.new
    lambda { @service.delete(customer) }.should raise_error(InvalidModelException, "Missing required parameters for delete")
  end

  it "exception is raised when we try to create an invalid account" do
    customer = Quickeebooks::Online::Model::Customer.new
    lambda { @service.create(customer) }.should raise_error(InvalidModelException)
  end

  it "cannot update an invalid customer" do
    customer = Quickeebooks::Online::Model::Customer.new
    customer.name = "John Doe"
    lambda { @service.update(customer) }.should raise_error(InvalidModelException)
  end

  it "can fetch a customer by id" do
    xml = onlineFixture("customer.xml")
    url = "#{@service.url_for_resource(Quickeebooks::Online::Model::Customer.resource_for_singular)}/99"
    FakeWeb.register_uri(:get, url, :status => ["200", "OK"], :body => xml)
    customer = @service.fetch_by_id(99)
    customer.name.should == "John Doe"
  end

  it "can update a customer" do
    xml2 = onlineFixture("customer2.xml")
    customer = Quickeebooks::Online::Model::Customer.new
    customer.name = "John Doe"
    customer.id = Quickeebooks::Online::Model::Id.new("1")
    customer.sync_token = 2

    url = "#{@service.url_for_resource(Quickeebooks::Online::Model::Customer.resource_for_singular)}/#{customer.id.value}"
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"], :body => xml2)
    updated = @service.update(customer)
    updated.name.should == "Billy Bob"
  end

  it 'Can update a fetched customer' do
    xml = onlineFixture("customer.xml")
    url = "#{@service.url_for_resource(Quickeebooks::Online::Model::Customer.resource_for_singular)}/99"
    FakeWeb.register_uri(:get, url, :status => ["200", "OK"], :body => xml)
    customer = @service.fetch_by_id(99)
    url = "#{@service.url_for_resource(Quickeebooks::Online::Model::Customer.resource_for_singular)}/#{customer.id.value}"
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"], :body => xml)
    updated = @service.update(customer)
  end

end
