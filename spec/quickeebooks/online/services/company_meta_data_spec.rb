require "spec_helper"
require "fakeweb"
require "oauth"
require "quickeebooks"

describe "Quickeebooks::Online::Service::CompanyMetaData" do
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

  it "can get the realm's company_meta_data record" do
    xml = File.read(File.dirname(__FILE__) + "/../../../xml/online/company_meta_data.xml")
    company_meta_data = Quickeebooks::Online::Service::CompanyMetaData.new(@oauth, @realm_id, @base_uri)
    url = "#{company_meta_data.url_for_resource("companymetadata")}"
    FakeWeb.register_uri(:get, url, :status => ["200", "OK"], :body => xml)
    company_meta_data = company_meta_data.load
    company_meta_data.registered_company_name.should == "Bay Area landscape services"
  end
end
