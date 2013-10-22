describe "Quickeebooks::Online::Service::SalesTerm" do
  before(:all) do
    construct_online_service :sales_term
  end

  it "can fetch a list of sales terms" do
    xml = onlineFixture("sales_terms.xml")
    url = @service.url_for_resource(Quickeebooks::Online::Model::SalesTerm.resource_for_collection)
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"], :body => xml)
    sales_terms = @service.list
    sales_terms.current_page.should == 1
    sales_terms.entries.count.should == 1
    sales_terms.entries.first.name.should == "Due on term"
  end

  it "can create a sales term" do
    xml = onlineFixture("sales_term.xml")
    url = @service.url_for_resource(Quickeebooks::Online::Model::SalesTerm.resource_for_singular)
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"], :body => xml)
    sales_term = Quickeebooks::Online::Model::SalesTerm.new
    sales_term.name = "My Sales Term"
    result = @service.create(sales_term)
    result.id.value.to_i.should > 0
  end

  it "can delete a sales term" do
    url = "#{@service.url_for_resource(Quickeebooks::Online::Model::SalesTerm.resource_for_singular)}/3?methodx=delete"
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"])
    sales_term = Quickeebooks::Online::Model::SalesTerm.new
    sales_term.id = Quickeebooks::Online::Model::Id.new("3")
    sales_term.sync_token = 0
    result = @service.delete(sales_term)
    result.should == true
  end

  it "can fetch a sales term by id" do
    xml = onlineFixture("sales_term.xml")
    url = "#{@service.url_for_resource(Quickeebooks::Online::Model::SalesTerm.resource_for_singular)}/1"
    FakeWeb.register_uri(:get, url, :status => ["200", "OK"], :body => xml)
    sales_term = @service.fetch_by_id(1)
    sales_term.name.should == "Due on receipt"
  end

  it "can update a sales term" do
    xml2 = onlineFixture("sales_term2.xml")
    sales_term = Quickeebooks::Online::Model::SalesTerm.new
    sales_term.id = Quickeebooks::Online::Model::Id.new("1")
    sales_term.sync_token = 0

    url = "#{@service.url_for_resource(Quickeebooks::Online::Model::SalesTerm.resource_for_singular)}/#{sales_term.id.value}"
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"], :body => xml2)
    updated = @service.update(sales_term)
    updated.name.should == "Due When I say"
  end

end
