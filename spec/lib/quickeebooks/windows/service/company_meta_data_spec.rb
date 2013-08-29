describe "Quickeebooks::Windows::Service::CompanyMetaData" do
  before(:all) do
    construct_windows_service :company_meta_data
  end

  it "can fetch the company meta data" do
    xml = windowsFixture("company_meta_data.xml")
    model = Quickeebooks::Windows::Model::CompanyMetaData
    FakeWeb.register_uri(:get, @service.url_for_resource(model::REST_RESOURCE), :status => ["200", "OK"], :body => xml)
    company_meta_data_response = @service.load

    company_meta_data_response.registered_company_name.should == "Castle Rock Construction"
  end
end
