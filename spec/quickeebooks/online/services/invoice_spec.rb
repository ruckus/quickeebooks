describe "Quickeebooks::Online::Service::Invoice" do
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
    @service = Quickeebooks::Online::Service::Invoice.new
    @service.access_token = @oauth
    @service.instance_eval {
      @realm_id = "9991111222"
    }
  end

  it "can create an invoice" do
    xml = onlineFixture("invoice.xml")

    url = @service.url_for_resource(Quickeebooks::Online::Model::Invoice.resource_for_singular)
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"], :body => xml)
    invoice = Quickeebooks::Online::Model::Invoice.new
    invoice.header = Quickeebooks::Online::Model::InvoiceHeader.new
    invoice.header.doc_number = "123"

    line_item = Quickeebooks::Online::Model::InvoiceLineItem.new
    line_item.item_id = Quickeebooks::Online::Model::Id.new("123")
    line_item.desc = "Pinor Noir 2005"
    line_item.unit_price = 188
    line_item.quantity = 2
    invoice.line_items << line_item

    result = @service.create(invoice)
    result.id.value.to_i.should > 0
  end

  it "can delete an invoice" do
    fixture_xml = onlineFixture("invoice.xml")
    response_xml = onlineFixture("deleted_invoice.xml")

    invoice_id = "123"
    url = @service.url_for_resource(Quickeebooks::Online::Model::Invoice.resource_for_singular) + "/13?methodx=delete"
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"], :body => response_xml)
    invoice = Quickeebooks::Online::Model::Invoice.from_xml(fixture_xml)
    
    result = @service.delete(invoice)
  end

end