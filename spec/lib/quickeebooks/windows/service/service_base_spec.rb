describe "Quickeebooks::Windows::Service::ServiceBase" do
  before(:all) do
    construct_windows_service :service_base
  end

  describe 'check_response' do
    it "should throw request exception with no options" do
      xml = onlineFixture('api_error.xml') # just use Online error fixture no difference
      response = Struct.new(:code, :body).new(400, xml)
      expect { @service.send(:check_response, response) }.to raise_error
    end

    it "should add post xml to request exception" do
      xml = onlineFixture('api_error.xml')
      xml2 = windowsFixture('customer.xml')
      response = Struct.new(:code, :body).new(400, xml)
      begin
        @service.send(:check_response, response, :request_xml => xml2)
      rescue IntuitRequestException => ex
        ex.request.should == xml2
      end
    end
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

    context 'logging' do

      it "should log if Quickbooks.log = true" do
        response_xml = wrap_result("<StartPage>1</StartPage><ChunkSize>10</ChunkSize>")
        FakeWeb.register_uri(:post, @url, :status => ["200", "OK"], :body => response_xml)
        Quickeebooks.log = true
        Quickeebooks.logger.should_receive(:info).at_least(1)
        @service.send(:do_http_post, @url)
        Quickeebooks.log = false
      end

      it "log_xml should handle a non-xml string" do
        assortment = [nil, 1, Object.new, [], { :foo => 'bar' }]
        assortment.each do |e|
          expect{ Quickeebooks::Windows::Service::ServiceBase.new.log_xml(e) }.to_not raise_error
        end
      end
    end

    context 'adding attributes to the main query tag' do
      it "should add 1 attribute" do
        @service.should_receive(:do_http_post).with(@url,
          post_request_query('ErroredObjectsOnly="true"'),
          {},
          {"Content-Type"=>"text/xml"})
        @service.send(:fetch_collection, Object, nil, nil, 1, 20, nil, :query_tag_attributes => { 'ErroredObjectsOnly' => 'true'})
      end

      it "should add 2 attributes" do
        @service.should_receive(:do_http_post).with(@url,
          post_request_query('ErroredObjectsOnly="true" ActiveOnly="true"'),
          {},
          {"Content-Type"=>"text/xml"})
        @service.send(:fetch_collection, Object, nil, nil, 1, 20, nil, :query_tag_attributes => { 'ErroredObjectsOnly' => 'true', 'ActiveOnly' => 'true'})
      end
    end
  end

  def post_request_query(attrs)
    xml = '<?xml version="1.0" encoding="utf-8"?>' + "\n"
    xml += '<FooQuery %s xmlns="http://www.intuit.com/sb/cdm/v2">'
    xml += '<StartPage>1</StartPage><ChunkSize>20</ChunkSize></FooQuery>'
    xml % [attrs]
  end
end
