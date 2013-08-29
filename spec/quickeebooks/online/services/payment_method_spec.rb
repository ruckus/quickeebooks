describe "Quickeebooks::Windows::Service::PaymentMethod" do
  before(:all) do
    construct_online_service :payment_method
  end

  it "can fetch a list of journal entries" do
    xml = onlineFixture("payment_methods.xml")
    url = @service.url_for_resource(Quickeebooks::Online::Model::PaymentMethod.resource_for_collection)
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"], :body => xml)
    payment_methods = @service.list
    payment_methods.current_page.should == 1
    payment_methods.entries.count.should == 6
  end

end
