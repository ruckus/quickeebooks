require "spec_helper"
require "fakeweb"
require "oauth"
require "quickeebooks/service/service_base"

describe "Quickeebooks::Service::ServiceBase" do
  before(:all) do
    FakeWeb.allow_net_connect = false
    qb_key = "key"
    qb_secret = "secreet"

    @realm_id = "9991111222"
    @oauth_consumer = OAuth::Consumer.new(qb_key, qb_key, {
        :site                 => "https://oauth.intuit.com",
        :request_token_path   => "/oauth/v1/get_request_token",
        :authorize_path       => "/oauth/v1/get_access_token",
        :access_token_path    => "/oauth/v1/get_access_token"
    })
  end
  
  it "can determine base url" do
    xml = File.read(File.dirname(__FILE__) + "/../../xml/user.xml")
    user_url = Quickeebooks::Service::ServiceBase::QB_BASE_URI + "/" + @realm_id
    FakeWeb.register_uri(:get, user_url, :status => ["200", "OK"], :body => xml)
    service = Quickeebooks::Service::ServiceBase.new(@oauth_consumer, @realm_id)
    service.base_uri.should_not == nil
    service.url_for_resource("customers").should == "https://qbo.intuit.com/qbo36/resource/customers/v2/#{@realm_id}"
  end
  
end