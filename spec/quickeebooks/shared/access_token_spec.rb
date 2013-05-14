describe "Quickeebooks::Shared::Service::AccessToken" do

  shared_examples "access_token_operations" do
    context "reconnect" do
      let(:reconnect_url){ "https://appcenter.intuit.com/api/v1/Connection/Reconnect" }

      it "can successfully reconnect" do
        xml = sharedFixture("reconnect_success.xml")
        FakeWeb.register_uri(:get, reconnect_url, :status => ["200", "OK"], :body => xml)

        response = @service.reconnect

        response.error?.should    be_false
        response.token.should  == "qye2eIdQ5H5yMyrlJflUWh712xfFXjyNnW1MfbC0rz04TfCP"
        response.secret.should == "cyDeUNQTkFzoR0KkDn7viN6uLQxWTobeEUKW7I79"
      end

      it "can handle expired tokens" do
        xml = sharedFixture("reconnect_error_expired.xml")
        FakeWeb.register_uri(:get, reconnect_url, :status => ["200", "OK"], :body => xml)

        response = @service.reconnect

        response.error?.should        be_true
        response.error_code.should    == "270"
        response.error_message.should == "OAuth Token Rejected"
      end

      it "can handle out-of-bounds refresh windows" do
        xml = sharedFixture("reconnect_error_out_of_bounds.xml")
        FakeWeb.register_uri(:get, reconnect_url, :status => ["200", "OK"], :body => xml)

        response = @service.reconnect

        response.error?.should        be_true
        response.error_code.should    == "212"
        response.error_message.should == "Token Refresh Window Out of Bounds"
      end


      it "can handle unapproved apps" do
        xml = sharedFixture("reconnect_error_not_approved.xml")
        FakeWeb.register_uri(:get, reconnect_url, :status => ["200", "OK"], :body => xml)

        response = @service.reconnect

        response.error?.should        be_true
        response.error_code.should    == "24"
        response.error_message.should == "Invalid App Token"
      end
    end

    context "disconnect" do
      let(:disconnect_url){ "https://appcenter.intuit.com/api/v1/Connection/Disconnect" }

      it "can successfully disconnect" do
        xml = sharedFixture("disconnect_success.xml")
        FakeWeb.register_uri(:get, disconnect_url, :status => ["200", "OK"], :body => xml)

        response = @service.disconnect

        response.error?.should be_false
      end

      it "can handle invalid tokens" do
        xml = sharedFixture("disconnect_invalid.xml")
        FakeWeb.register_uri(:get, disconnect_url, :status => ["200", "OK"], :body => xml)

        response = @service.disconnect

        response.error?.should        be_true
        response.error_code.should    == "270"
        response.error_message.should == "OAuth Token rejected"
      end
    end
  end

  context "online" do
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

      @service = Quickeebooks::Online::Service::AccessToken.new
      @service.access_token = @oauth
      @service.instance_eval {
        @realm_id = "9991111222"
      }
    end

    it_behaves_like "access_token_operations"
  end

  context "windows" do
    before(:all) do
      FakeWeb.allow_net_connect = false
      qb_key = "key"
      qb_secret = "secreet"

      @realm_id = "9991111222"
      #@base_uri = "https://qbo.intuit.com/qbo36"
      @oauth_consumer = OAuth::Consumer.new(qb_key, qb_key, {
          :site                 => "https://oauth.intuit.com",
          :request_token_path   => "/oauth/v1/get_request_token",
          :authorize_path       => "/oauth/v1/get_access_token",
          :access_token_path    => "/oauth/v1/get_access_token"
      })
      @oauth = OAuth::AccessToken.new(@oauth_consumer, "blah", "blah")

      @service = Quickeebooks::Windows::Service::AccessToken.new

      @service.access_token = @oauth
      @service.instance_eval {
        @realm_id = "9991111222"
      }
    end

    it_behaves_like "access_token_operations"
  end
end
