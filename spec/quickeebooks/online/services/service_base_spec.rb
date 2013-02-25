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

  describe "#fetch_collection" do
    before do
      @model = mock(Object)
      @model.stub(:resource_for_collection){ "foos" }

      @url = @service.url_for_resource(@model.resource_for_collection)
    end

    it "uses all default values" do
      @service.should_receive(:do_http_post).with(@url,
        "PageNum=1&ResultsPerPage=20",
        {},
        {"Content-Type"=>"application/x-www-form-urlencoded"})

      @service.send(:fetch_collection, @model)
    end

    it "filters" do

      filter = Quickeebooks::Online::Service::Filter.new(:text, :field => "Name", :value => "Smith")

      @service.should_receive(:do_http_post).with(@url,
        "Filter=Name+%3AEQUALS%3A+Smith&PageNum=1&ResultsPerPage=20",
        {},
        {"Content-Type"=>"application/x-www-form-urlencoded"})

      @service.send(:fetch_collection, @model, [filter])
    end

    it "paginates" do
      @service.should_receive(:do_http_post).with(@url,
        "PageNum=2&ResultsPerPage=20",
        {},
        {"Content-Type"=>"application/x-www-form-urlencoded"})

      @service.send(:fetch_collection, @model, nil, 2)
    end

    it "changes per_page" do
      @service.should_receive(:do_http_post).with(@url,
        "PageNum=1&ResultsPerPage=10",
        {},
        {"Content-Type"=>"application/x-www-form-urlencoded"})

      @service.send(:fetch_collection, @model, nil, 1, 10)
    end

    it "sorts" do
      sorter = Quickeebooks::Online::Service::Sort.new('FamilyName', 'AtoZ')

      @service.should_receive(:do_http_post).with(@url,
        "PageNum=1&ResultsPerPage=20&Sort=FamilyName+AtoZ",
        {},
        {"Content-Type"=>"application/x-www-form-urlencoded"})

      @service.send(:fetch_collection, @model, nil, 1, 20, sorter)
    end
  end
end
