describe "Quickeebooks::Online::Service::Employee" do
  before(:all) do
    construct_online_service :employee
  end

  it "can fetch a list of employees" do
    xml = onlineFixture("employees.xml")
    url = @service.url_for_resource(Quickeebooks::Online::Model::Employee.resource_for_collection)
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"], :body => xml)
    employees = @service.list
    employees.current_page.should == 1
    employees.entries.count.should == 1
    employees.entries.first.name.should == "John Simpson"
  end

  it "can create a employee" do
    xml = onlineFixture("employee.xml")
    url = @service.url_for_resource(Quickeebooks::Online::Model::Employee.resource_for_singular)
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"], :body => xml)
    employee = Quickeebooks::Online::Model::Employee.new
    employee.name = "John Doe"
    result = @service.create(employee)
    result.id.value.to_i.should > 0
  end

  it "can delete a employee" do
    url = "#{@service.url_for_resource(Quickeebooks::Online::Model::Employee.resource_for_singular)}/11?methodx=delete"
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"])
    employee = Quickeebooks::Online::Model::Employee.new
    employee.id = Quickeebooks::Online::Model::Id.new("11")
    employee.sync_token = 0
    result = @service.delete(employee)
    result.should == true
  end

  it "cannot delete a employee with missing required fields for deletion" do
    employee = Quickeebooks::Online::Model::Employee.new
    expect { @service.delete(employee) }.to raise_exception(InvalidModelException, "Missing required parameters for delete")
  end

  it "exception is raised when we try to create an invalid account" do
    employee = Quickeebooks::Online::Model::Employee.new
    expect { @service.create(employee) }.to raise_exception InvalidModelException
  end

  it "cannot update an invalid employee" do
    employee = Quickeebooks::Online::Model::Employee.new
    employee.name = "John Bilby"
    expect { @service.update(employee) }.to raise_exception InvalidModelException
  end

  it "can fetch a employee by id" do
    xml = onlineFixture("employee.xml")
    url = "#{@service.url_for_resource(Quickeebooks::Online::Model::Employee.resource_for_singular)}/11"
    FakeWeb.register_uri(:get, url, :status => ["200", "OK"], :body => xml)
    employee = @service.fetch_by_id(11)
    employee.name.should == "John Simpson"
  end

  it "can update a employee" do
    xml2 = onlineFixture("employee2.xml")
    employee = Quickeebooks::Online::Model::Employee.new
    employee.name = "John Doe"
    employee.id = Quickeebooks::Online::Model::Id.new("1")
    employee.sync_token = 2

    url = "#{@service.url_for_resource(Quickeebooks::Online::Model::Employee.resource_for_singular)}/#{employee.id.value}"
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"], :body => xml2)
    updated = @service.update(employee)
    updated.name.should == "John Doe"
  end

  it 'Can update a fetched employee' do
    xml = onlineFixture("employee.xml")
    url = "#{@service.url_for_resource(Quickeebooks::Online::Model::Employee.resource_for_singular)}/11"
    FakeWeb.register_uri(:get, url, :status => ["200", "OK"], :body => xml)
    employee = @service.fetch_by_id(11)
    url = "#{@service.url_for_resource(Quickeebooks::Online::Model::Employee.resource_for_singular)}/#{employee.id.value}"
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"], :body => xml)
    updated = @service.update(employee)
  end

end
