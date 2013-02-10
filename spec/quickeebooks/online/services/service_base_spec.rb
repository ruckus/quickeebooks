require "fakeweb"
require "oauth"
require "quickeebooks/online/service/service_base"

describe "Quickeebooks::Online::Service::ServiceBase" do
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
    @oauth = OAuth::AccessToken.new(@oauth_consumer, "blah", "blah")

    xml = onlineFixture("user.xml")
    user_url = Quickeebooks::Online::Service::ServiceBase::QB_BASE_URI + "/" + @realm_id
    FakeWeb.register_uri(:get, user_url, :status => ["200", "OK"], :body => xml)
    @service = Quickeebooks::Online::Service::ServiceBase.new
    @service.access_token = @oauth
    @service.instance_eval {
      @realm_id = "9991111222"
    }
  end

  it "can determine login_name" do
    xml = onlineFixture("user.xml")
    user_url = "https://qbo.intuit.com/qbo1/rest/user/v2/#{@realm_id}"
    FakeWeb.register_uri(:get, user_url, :status => ["200", "OK"], :body => xml)
    @service.login_name.should == 'foo@example.com'
  end

end
