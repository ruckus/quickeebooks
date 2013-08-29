describe "Quickeebooks::Windows::Service::Item" do
  before(:all) do
    construct_windows_service :item
  end

  it "can fetch a list of Items" do
    xml = windowsFixture("items.xml")
    model = Quickeebooks::Windows::Model::Item
    FakeWeb.register_uri(:post, @service.url_for_resource(model::REST_RESOURCE), :status => ["200", "OK"], :body => xml)
    items = @service.list
    items.entries.count.should == 2
    gruner = items.entries.first
    gruner.name.should == "FGVS09"

  end

  it "can fetch an Item by ID" do
    xml = windowsFixture("item.xml")
    model = Quickeebooks::Windows::Model::Item
    FakeWeb.register_uri(:get, "#{@service.url_for_resource(model::REST_RESOURCE)}/407?idDomain=QB", :status => ["200", "OK"], :body => xml)
    customer = @service.fetch_by_id(407)
    customer.name.should == "DWCSH11"
  end

end
