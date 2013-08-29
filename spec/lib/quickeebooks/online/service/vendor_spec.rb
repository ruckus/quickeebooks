describe "Quickeebooks::Online::Service::Vendor" do
  before(:all) do
    construct_online_service :vendor
  end

  it "can fetch a list of vendors" do
    xml = onlineFixture("vendors.xml")
    url = @service.url_for_resource(Quickeebooks::Online::Model::Vendor.resource_for_collection)
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"], :body => xml)
    accounts = @service.list
    accounts.current_page.should == 1
    accounts.entries.count.should == 2
    accounts.entries.first.name.should == "Digital"
  end

  it "can create a vendor" do
    xml = onlineFixture("vendor.xml")
    url = @service.url_for_resource(Quickeebooks::Online::Model::Vendor.resource_for_singular)
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"], :body => xml)
    vendor = Quickeebooks::Online::Model::Vendor.new
    vendor.name = "Digital"
    vendor.is_1099 = true
    result = @service.create(vendor)
    result.id.value.to_i.should > 0
    result.is_1099?.should be_true
  end

  it "can delete a vendor" do
    url = "#{@service.url_for_resource(Quickeebooks::Online::Model::Vendor.resource_for_singular)}/11?methodx=delete"
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"])
    vendor = Quickeebooks::Online::Model::Vendor.new
    vendor.id = Quickeebooks::Online::Model::Id.new("11")
    vendor.sync_token = 0
    result = @service.delete(vendor)
    result.should == true
  end

  it "cannot delete a vendor with missing required fields for deletion" do
    vendor = Quickeebooks::Online::Model::Vendor.new
    expect { @service.delete(vendor) }.to raise_exception(InvalidModelException, "Missing required parameters for delete")
  end

  it "exception is raised when we try to create an invalid account" do
    vendor = Quickeebooks::Online::Model::Vendor.new
    expect { @service.create(vendor) }.to raise_exception InvalidModelException
  end

  it "cannot update an invalid vendor" do
    vendor = Quickeebooks::Online::Model::Vendor.new
    vendor.name = "John Bilby"
    expect { @service.update(vendor) }.to raise_exception InvalidModelException
  end

  it "can fetch a vendor by id" do
    xml = onlineFixture("vendor.xml")
    url = "#{@service.url_for_resource(Quickeebooks::Online::Model::Vendor.resource_for_singular)}/11"
    FakeWeb.register_uri(:get, url, :status => ["200", "OK"], :body => xml)
    vendor = @service.fetch_by_id(11)
    vendor.name.should == "Digital"
  end

  it "can update a vendor" do
    xml2 = onlineFixture("vendor2.xml")
    vendor = Quickeebooks::Online::Model::Vendor.new
    vendor.name = "Digital NYC"
    vendor.id = Quickeebooks::Online::Model::Id.new("1")
    vendor.sync_token = 2

    url = "#{@service.url_for_resource(Quickeebooks::Online::Model::Vendor.resource_for_singular)}/#{vendor.id.value}"
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"], :body => xml2)
    updated = @service.update(vendor)
    updated.name.should == "Digital NYC"
  end

  it 'Can update a fetched vendor' do
    xml = onlineFixture("vendor.xml")
    url = "#{@service.url_for_resource(Quickeebooks::Online::Model::Vendor.resource_for_singular)}/11"
    FakeWeb.register_uri(:get, url, :status => ["200", "OK"], :body => xml)
    vendor = @service.fetch_by_id(11)
    url = "#{@service.url_for_resource(Quickeebooks::Online::Model::Vendor.resource_for_singular)}/#{vendor.id.value}"
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"], :body => xml)
    updated = @service.update(vendor)
  end

end
