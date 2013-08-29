describe "Quickeebooks::Windows::Service::PaymentMethod" do
  before(:all) do
    construct_windows_service :payment_method
  end

  it "can fetch a list of payment methods" do
    xml = windowsFixture("payment_methods.xml")

    model = Quickeebooks::Windows::Model::PaymentMethod
    FakeWeb.register_uri(:post,
                         @service.url_for_resource(model::REST_RESOURCE),
                         :status => ["200", "OK"],
                         :body => xml)
    methods = @service.list
    methods.entries.count.should == 9

    method1 = methods.entries.first
    method1.id.value.should == "9"
    method1.name.should == "E-Check"
  end
end
