describe "Quickeebooks::Windows::Service::SalesTax" do
  before(:all) do
    construct_windows_service :sales_tax
  end

  it "can fetch a list of sales taxes" do
    xml = windowsFixture("sales_taxes.xml")
    model = Quickeebooks::Windows::Model::SalesTax
    FakeWeb.register_uri(:post, @service.url_for_resource(model::REST_RESOURCE), :status => ["200", "OK"], :body => xml)
    shipping_methods = @service.list
    shipping_methods.entries.count.should == 2

    sf = shipping_methods.entries.detect { |sm| sm.name == "San Francisco County" }
    sf.should_not == nil
    sf.id.value.should == "80"
    sf.desc.should == 'Sales Tax - San Francisco'
    sf.tax_rate.should == 8.5

  end

end
