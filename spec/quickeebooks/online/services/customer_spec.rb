require "spec_helper"
require "fakeweb"
require "oauth"
require "quickeebooks"

describe "Quickeebooks::Online::Service::Customer" do
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
    
    @service = Quickeebooks::Online::Service::Customer.new
    @service.access_token = @oauth
    @service.instance_eval {
      @realm_id = "9991111222"
    }
    @service.base_uri = @base_uri
    determine_base_url = @service.qb_base_uri_with_realm_id
    xml = File.read(File.dirname(__FILE__) + "/../../../xml/online/determine_base_url.xml")
    FakeWeb.register_uri(:get, determine_base_url, :status => ["200", "OK"], :body => xml)    
  end
  
  it "can fetch a list of customers" do
    xml = File.read(File.dirname(__FILE__) + "/../../../xml/online/customers.xml")
    url = @service.url_for_resource(Quickeebooks::Online::Model::Customer.resource_for_collection)
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"], :body => xml)
    accounts = @service.list
    accounts.current_page.should == 1
    accounts.entries.count.should == 3
    accounts.entries.first.name.should == "John Doe"
  end

  it "can fetch a list of customers with filters" do
    xml = File.read(File.dirname(__FILE__) + "/../../../xml/online/customers.xml")
    url = @service.url_for_resource(Quickeebooks::Online::Model::Customer.resource_for_collection)
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"], :body => xml)
    accounts = @service.list
    accounts.current_page.should == 1
    accounts.entries.count.should == 3
    accounts.entries.first.name.should == "John Doe"
  end
  
  it "can create a customer" do
    xml = File.read(File.dirname(__FILE__) + "/../../../xml/online/customer.xml")
    url = @service.url_for_resource(Quickeebooks::Online::Model::Customer.resource_for_singular)
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"], :body => xml)
    customer = Quickeebooks::Online::Model::Customer.new
    customer.name = "Billy Bob"
    result = @service.create(customer)
    result.id.value.to_i.should > 0
  end
  
  it "can delete a customer" do
    url = "#{@service.url_for_resource(Quickeebooks::Online::Model::Customer.resource_for_singular)}/99"
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
    xml = File.read(File.dirname(__FILE__) + "/../../../xml/online/customer.xml")
    url = "#{@service.url_for_resource(Quickeebooks::Online::Model::Customer.resource_for_singular)}/99"
    FakeWeb.register_uri(:get, url, :status => ["200", "OK"], :body => xml)
    customer = @service.fetch_by_id(99)
    customer.name.should == "John Doe"
  end

  it "can update a customer" do
    xml2 = File.read(File.dirname(__FILE__) + "/../../../xml/online/customer2.xml")
    customer = Quickeebooks::Online::Model::Customer.new
    customer.name = "John Doe"
    customer.id = Quickeebooks::Online::Model::Id.new("1")
    customer.sync_token = 2
    
    url = "#{@service.url_for_resource(Quickeebooks::Online::Model::Customer.resource_for_singular)}/#{customer.id.value}"
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"], :body => xml2)
    updated = @service.update(customer)
    updated.name.should == "Billy Bob"
  end

  
end