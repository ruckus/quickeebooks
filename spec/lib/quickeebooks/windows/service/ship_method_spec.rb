describe "Quickeebooks::Windows::Service::ShipMethod" do
  before(:all) do
    construct_windows_service :ship_method
  end

  it "can fetch a list of shipping methods" do
    xml = windowsFixture("ship_methods.xml")
    model = Quickeebooks::Windows::Model::ShipMethod
    FakeWeb.register_uri(:post, @service.url_for_resource(model::REST_RESOURCE), :status => ["200", "OK"], :body => xml)
    shipping_methods = @service.list
    shipping_methods.entries.count.should == 15

    vinlux = shipping_methods.entries.detect { |sm| sm.name == "Vinlux" }
    vinlux.should_not == nil
    vinlux.id.value.should == "13"
  end

end
