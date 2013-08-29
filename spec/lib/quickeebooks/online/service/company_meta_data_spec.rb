describe "Quickeebooks::Online::Service::CompanyMetaData" do
  before(:all) do
    construct_online_service :company_meta_data
  end

  it "can get the realm's company_meta_data record" do
    xml = onlineFixture("company_meta_data.xml")
    url = @service.url_for_resource(Quickeebooks::Online::Model::CompanyMetaData.resource_for_singular)
    FakeWeb.register_uri(:get, url, :status => ["200", "OK"], :body => xml)
    company_meta_data_response = @service.load
    company_meta_data_response.registered_company_name.should == "Bay Area landscape services"
  end
end
