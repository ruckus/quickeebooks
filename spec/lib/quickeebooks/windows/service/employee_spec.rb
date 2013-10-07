describe "Quickeebooks::Windows::Service::Employee" do
  before(:all) do
    construct_windows_service :employee
  end

  it "can fetch a list of employees" do
    xml = windowsFixture("employees.xml")
    model = Quickeebooks::Windows::Model::Employee
    FakeWeb.register_uri(:post, @service.url_for_resource(model::REST_RESOURCE), :status => ["200", "OK"], :body => xml)
    employees = @service.list
    employees.entries.count.should == 1
    rogets = employees.entries.first
    rogets.name.should == "Rogets, Charles"

    rogets_address = rogets.billing_address
    rogets_address.should_not == nil
    rogets_address.line1.should == "Charles Rogets"
    rogets_address.city.should == "Los Angeles"
    rogets_address.state.should == "CA"
    rogets_address.postal_code.should == "90064"

    rogets_active = rogets.active
    rogets_active.should == "true"

  end

  it "cannot create a employee without a name" do
    employee = Quickeebooks::Windows::Model::Employee.new
    lambda do
      @service.create(employee)
    end.should raise_error(InvalidModelException)

    employee.valid?.should == false
    employee.errors.keys.include?(:name).should == true
  end

  it "cannot create a employee without a type_of attribute" do
    employee = Quickeebooks::Windows::Model::Employee.new
    lambda do
      @service.create(employee)
    end.should raise_error(InvalidModelException)
    employee.errors.keys.include?(:type_of).should == true
  end

  it "cannot create a employee with invalid name" do
    employee = Quickeebooks::Windows::Model::Employee.new
    employee.name = "Bobs:Plumbing"
    lambda do
      @service.create(employee)
    end.should raise_error(InvalidModelException)

    employee.valid?.should == false
    employee.errors.keys.include?(:name).should == true
  end

  it "can create a employee" do
    xml = windowsFixture("employee_create_success.xml")
    model = Quickeebooks::Windows::Model::Employee
    employee = Quickeebooks::Windows::Model::Employee.new

    FakeWeb.register_uri(:post, @service.url_for_resource(model::REST_RESOURCE), :status => ["200", "OK"], :body => xml)

    employee.type_of = "Person"
    employee.name = "Bugs Bunny"
    employee.given_name = "Bugs"
    employee.family_name = "Bunny"
    email = Quickeebooks::Windows::Model::Email.new
    email.address = "foo@bar.com"
    email.tag = "Business"
    employee.email = email
    address = Quickeebooks::Windows::Model::Address.new
    address.tag = "Billing"
    address.line1 = "123 Main St."
    address.city = "San Francisco"
    address.country_sub_division_code = "CA"
    address.postal_code = "94117"
    address.country = "USA"
    employee.address = address

    create_response = @service.create(employee)
    create_response.success?.should == true
    create_response.success.party_role_ref.id.value.should == "155031"
    create_response.success.request_name.should == "EmployeeAdd"
  end

end
