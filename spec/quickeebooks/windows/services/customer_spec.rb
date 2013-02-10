describe "Quickeebooks::Windows::Service::Customer" do
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

  it "can fetch a list of customers" do
    xml = windowsFixture("customers.xml")
    model = Quickeebooks::Windows::Model::Customer
    service = Quickeebooks::Windows::Service::Customer.new
    service.access_token = @oauth
    service.realm_id = @realm_id
    FakeWeb.register_uri(:post, service.url_for_resource(model::REST_RESOURCE), :status => ["200", "OK"], :body => xml)
    accounts = service.list
    accounts.entries.count.should == 3
    wine_house = accounts.entries.first
    wine_house.name.should == "Wine House"

    billing_address = wine_house.billing_address
    billing_address.should_not == nil
    billing_address.line2.should == "2311 Maple Ave"
    billing_address.city.should == "Los Angeles"
    billing_address.state.should == "CA"
    billing_address.postal_code.should == "90064"

    email = wine_house.email
    email.should_not == nil
    email.address.should == "no-reply@winehouse.com"
    email.tag.should == "Business"
    email.default.should == "1"
  end

  it "can fetch a customer by ID" do
    xml = windowsFixture("fetch_customer_by_id.xml")
    model = Quickeebooks::Windows::Model::Customer
    service = Quickeebooks::Windows::Service::Customer.new
    service.access_token = @oauth
    service.realm_id = @realm_id
    FakeWeb.register_uri(:get, "#{service.url_for_resource(model::REST_RESOURCE)}/341?idDomain=QB", :status => ["200", "OK"], :body => xml)
    customer = service.fetch_by_id(341)
    customer.name.should == "Wine Stop"
  end

  it "cannot create a customer without a name" do
    customer = Quickeebooks::Windows::Model::Customer.new
    service = Quickeebooks::Windows::Service::Customer.new
    service.access_token = @oauth
    service.realm_id = @realm_id
    lambda do
      service.create(customer)
    end.should raise_error(InvalidModelException)

    customer.valid?.should == false
    customer.errors.keys.include?(:name).should == true
  end

  it "cannot create a customer without a type_of attribute" do
    customer = Quickeebooks::Windows::Model::Customer.new
    service = Quickeebooks::Windows::Service::Customer.new
    service.access_token = @oauth
    service.realm_id = @realm_id
    lambda do
      service.create(customer)
    end.should raise_error(InvalidModelException)
    customer.errors.keys.include?(:type_of).should == true
  end

  it "cannot create a customer with invalid name" do
    customer = Quickeebooks::Windows::Model::Customer.new
    service = Quickeebooks::Windows::Service::Customer.new
    service.access_token = @oauth
    service.realm_id = @realm_id
    customer.name = "Bobs:Plumbing"
    lambda do
      service.create(customer)
    end.should raise_error(InvalidModelException)

    customer.valid?.should == false
    customer.errors.keys.include?(:name).should == true
  end

  it "cannot create a customer with no address" do
    customer = Quickeebooks::Windows::Model::Customer.new
    service = Quickeebooks::Windows::Service::Customer.new
    service.access_token = @oauth
    service.realm_id = @realm_id
    customer.name = "Bobs Plumbing"
    lambda do
      service.create(customer)
    end.should raise_error(InvalidModelException)

    customer.valid?.should == false
    customer.errors.keys.include?(:addresses).should == true
  end

  it "cannot create a customer with an invalid email" do
    customer = Quickeebooks::Windows::Model::Customer.new
    service = Quickeebooks::Windows::Service::Customer.new
    service.access_token = @oauth
    service.realm_id = @realm_id
    customer.name = "Bobs Plumbing"
    customer.email_address = "foobar.com"
    lambda do
      service.create(customer)
    end.should raise_error(InvalidModelException)

    customer.valid?.should == false
    customer.errors.keys.include?(:email).should == true
  end

  it "can create a customer" do
    xml = windowsFixture("customer_create_success.xml")
    service = Quickeebooks::Windows::Service::Customer.new
    model = Quickeebooks::Windows::Model::Customer
    customer = Quickeebooks::Windows::Model::Customer.new

    service.access_token = @oauth
    service.realm_id = @realm_id
    FakeWeb.register_uri(:post, service.url_for_resource(model::REST_RESOURCE), :status => ["200", "OK"], :body => xml)

    customer.type_of = "Person"
    customer.name = "Bobs Plumbing"
    email = Quickeebooks::Windows::Model::Email.new
    email.address = "foo@bar.com"
    email.tag = "Business"
    customer.email = email
    billing_address = Quickeebooks::Windows::Model::Address.new
    billing_address.tag = "Billing"
    billing_address.line1 = "123 Main St."
    billing_address.city = "San Francisco"
    billing_address.country_sub_division_code = "CA"
    billing_address.postal_code = "94117"
    billing_address.country = "USA"
    customer.address = billing_address
    create_response = service.create(customer)
    create_response.success?.should == true
    create_response.success.party_role_ref.id.value.should == "6762304"
    create_response.success.request_name.should == "CustomerAdd"
  end

  it "can update a customer name" do
    customer_xml = windowsFixture("customer.xml")
    update_response_xml = windowsFixture("customer_update_success.xml")
    service = Quickeebooks::Windows::Service::Customer.new
    model = Quickeebooks::Windows::Model::Customer
    customer = model.from_xml(customer_xml)
    customer.name.should == "Wine House"

    service.access_token = @oauth
    service.realm_id = @realm_id
    FakeWeb.register_uri(:post, service.url_for_resource(model::REST_RESOURCE), :status => ["200", "OK"], :body => update_response_xml)

    # change the name
    customer.name = "Acme Cafe"
    update_response = service.update(customer)
    update_response.success?.should == true
    update_response.success.party_role_ref.id.value.should == "6762304"
    update_response.success.request_name.should == "CustomerMod"
  end


end