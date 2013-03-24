describe "Quickeebooks::Windows::Service::ServiceBase" do
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

    @service = Quickeebooks::Windows::Service::ServiceBase.new
    @service.access_token = @oauth
    @service.instance_eval {
      @realm_id = "9991111222"
    }
  end

  describe "#fetch_collection" do
    let(:default_params){ "<StartPage>1</StartPage><ChunkSize>20</ChunkSize>" }

    before do
      stub_const("Object::REST_RESOURCE", "foos")
      stub_const("Object::XML_NODE",      "Foo")

      @url = @service.url_for_resource(Object::REST_RESOURCE)
    end

    def wrap_result(res)
      %Q{<?xml version="1.0" encoding="utf-8"?>\n<FooQuery xmlns="http://www.intuit.com/sb/cdm/v2">#{res}</FooQuery>}
    end

    it "uses all default values" do
      @service.should_receive(:do_http_post).with(@url,
        wrap_result(default_params),
        {},
        {"Content-Type"=>"text/xml"})

      @service.send(:fetch_collection, Object)
    end

    it "queries arbitrary things" do
      @service.should_receive(:do_http_post).with(@url,
        wrap_result("#{default_params}<Something>42</Something>"),
        {},
        {"Content-Type"=>"text/xml"})

      @service.send(:fetch_collection, Object, "<Something>42</Something>")
    end

    it "filters" do
      filter = Quickeebooks::Windows::Service::Filter.new(:boolean, :field => "IsPaid", :value => true)

      @service.should_receive(:do_http_post).with(@url,
        wrap_result("#{default_params}<IsPaid>true</IsPaid>"),
        {},
        {"Content-Type"=>"text/xml"})

      @service.send(:fetch_collection, Object, nil, [filter])
    end

    it "paginates" do
      @service.should_receive(:do_http_post).with(@url,
        wrap_result("<StartPage>2</StartPage><ChunkSize>20</ChunkSize>"),
        {},
        {"Content-Type"=>"text/xml"})

      @service.send(:fetch_collection, Object, nil, nil, 2)
    end

    it "changes per_page" do
      @service.should_receive(:do_http_post).with(@url,
        wrap_result("<StartPage>1</StartPage><ChunkSize>10</ChunkSize>"),
        {},
        {"Content-Type"=>"text/xml"})

      @service.send(:fetch_collection, Object, nil, nil, 1, 10)
    end

    it "sorts" do
      sorter = Quickeebooks::Windows::Service::Sort.new('FamilyName', 'Ascending')

      @service.should_receive(:do_http_post).with(@url,
        wrap_result("#{default_params}<SortByColumn sortOrder=\"Ascending\">FamilyName</SortByColumn>"),
        {},
        {"Content-Type"=>"text/xml"})

      @service.send(:fetch_collection, Object, nil, nil, 1, 20, sorter)
    end
  end
end
