require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')
require "fakeweb"
require "oauth"
require "quickeebooks"

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
    xml = File.read(File.dirname(__FILE__) + "/../../../xml/windows/customers.xml")
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

end