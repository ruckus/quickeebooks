require "spec_helper"
require "fakeweb"
require "oauth"
require "quickeebooks/service/account"

describe "Quickeebooks::Service::Account" do
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
    @oauth = OAuth::ConsumerToken.new(@oauth_consumer, "blah", "blah")
  end
  
  it "receives 404 from invalid base URL" do
    uri = "https://qbo.intuit.com/invalid"
    service = Quickeebooks::Service::Account.new(@oauth, @realm_id, uri)
    FakeWeb.register_uri(:post, service.url_for_resource("accounts"), :status => ["200", "OK"], :body => "blah")
    lambda { service.list }.should raise_error(IntuitRequestException)
  end
  
  it "can fetch a list of accounts" do
    xml = File.read(File.dirname(__FILE__) + "/../../xml/accounts.xml")
    service = Quickeebooks::Service::Account.new(@oauth, @realm_id, @base_uri)
    FakeWeb.register_uri(:post, service.url_for_resource("accounts"), :status => ["200", "OK"], :body => xml)
    accounts = service.list
    accounts.current_page.should == 1
    accounts.entries.count.should == 10
    accounts.entries.first.current_balance.should == 6200
  end
  
  it "can create an account" do
    xml = File.read(File.dirname(__FILE__) + "/../../xml/account.xml")
    service = Quickeebooks::Service::Account.new(@oauth, @realm_id, @base_uri)
    FakeWeb.register_uri(:post, service.url_for_resource("account"), :status => ["200", "OK"], :body => xml)
    account = Quickeebooks::Model::Account.new
    account.name = "Billy Bob"
    account.sub_type = "AccountsPayable"
    account.valid?.should == true
    result = service.create(account)
    result.id.to_i.should > 0
  end

  it "can delete an account" do
    service = Quickeebooks::Service::Account.new(@oauth, @realm_id, @base_uri)
    url = "#{service.url_for_resource("account")}/99?methodx=delete"
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"])
    account = Quickeebooks::Model::Account.new
    account.id = 99
    account.sync_token = 0
    result = service.delete(account)
    result.should == true
  end
  
  it "cannot delete an account with missing required fields for deletion" do
    service = Quickeebooks::Service::Account.new(@oauth, @realm_id, @base_uri)
    account = Quickeebooks::Model::Account.new
    lambda { service.delete(account) }.should raise_error(InvalidModelException, "Missing required parameters for delete")
  end
  
  it "exception is raised when we try to create an invalid account" do
    account = Quickeebooks::Model::Account.new
    service = Quickeebooks::Service::Account.new(@oauth, @realm_id, @base_uri)
    lambda { service.create(account) }.should raise_error(InvalidModelException)
  end
  
  it "can fetch an account by id" do
    xml = File.read(File.dirname(__FILE__) + "/../../xml/account.xml")
    service = Quickeebooks::Service::Account.new(@oauth, @realm_id, @base_uri)
    url = "#{service.url_for_resource("account")}/99"
    FakeWeb.register_uri(:get, url, :status => ["200", "OK"], :body => xml)
    account = service.fetch_by_id(99)
    account.name.should == "Billy Bob"
  end
  
end