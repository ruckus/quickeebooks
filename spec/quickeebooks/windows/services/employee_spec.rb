describe "Quickeebooks::Windows::Service::Employee" do
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

  it "can fetch a list of employees" do
    xml = windowsFixture("employees.xml")
    model = Quickeebooks::Windows::Model::Employee
    service = Quickeebooks::Windows::Service::Employee.new
    service.access_token = @oauth
    service.realm_id = @realm_id
    FakeWeb.register_uri(:post, service.url_for_resource(model::REST_RESOURCE), :status => ["200", "OK"], :body => xml)
    employees = service.list
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

end