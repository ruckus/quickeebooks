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
  end
  
  it "can fetch a list of accounts" do
    xml = File.read(File.dirname(__FILE__) + "/../../xml/accounts.xml")
    service = Quickeebooks::Service::Account.new(@oauth_consumer, @realm_id, @base_uri)
    FakeWeb.register_uri(:post, service.url_for_resource("accounts"), :status => ["200", "OK"], :body => xml)
    accounts = service.list
    accounts.count.should == 10
    accounts.first.current_balance.should == 6200
  end
  
end