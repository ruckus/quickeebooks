describe "Quickeebooks::Windows::Service::SalesRep" do
  before(:all) do
    construct_windows_service :sales_rep
  end

  it "can fetch a list of sales reps" do
    xml = windowsFixture("sales_reps.xml")

    model = Quickeebooks::Windows::Model::SalesRep
    FakeWeb.register_uri(:post, @service.url_for_resource(model::REST_RESOURCE), :status => ["200", "OK"], :body => xml)
    reps = @service.list
    reps.entries.count.should == 10

    lukas = reps.entries.detect { |sr| sr.id.value == "13" }
    lukas.should_not == nil
    lukas.external_key.value.should == "13"
    lukas.initials.should == "LB"
    lukas.vendor.vendor_id.value.should == "275"
    lukas.vendor.vendor_name.should == "Lukas Billybob"

    other_name = reps.entries.detect { |r| r.other_name? }
    other_name.should_not == nil
    other_name.other_name.other_name_id.value.should == "96"
    other_name.other_name.other_name_name.should == "Samples."
  end

end
