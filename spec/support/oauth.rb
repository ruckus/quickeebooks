def construct_oauth
  FakeWeb.allow_net_connect = false
  qb_key = "key"
  qb_secret = "secreet"

  @realm_id = "9991111222"
  @oauth_consumer = OAuth::Consumer.new(qb_key, qb_secret, {
      :site               => "https://oauth.intuit.com",
      :request_token_path => "/oauth/v1/get_request_token",
      :authorize_path     => "/oauth/v1/get_access_token",
      :access_token_path  => "/oauth/v1/get_access_token"
  })
  @oauth = OAuth::AccessToken.new(@oauth_consumer, "blah", "blah")
end

def construct_windows_service(model)
  construct_oauth

  @service = "Quickeebooks::Windows::Service::#{model.to_s.camelcase}".constantize.new
  @service.access_token = @oauth
  @service.instance_eval {
    @realm_id = "9991111222"
  }
end

def construct_online_service(model)
  construct_oauth

  @service = "Quickeebooks::Online::Service::#{model.to_s.camelcase}".constantize.new
  @service.access_token = @oauth
  @service.instance_eval {
    @realm_id = "9991111222"
  }
end
