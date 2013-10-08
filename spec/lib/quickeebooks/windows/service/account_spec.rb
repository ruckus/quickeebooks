describe "Quickeebooks::Windows::Service::Account" do
  before(:all) do
    construct_windows_service :account
  end

  it "can create an account" do
    xml = windowsFixture("account_create_success.xml")
    model = Quickeebooks::Windows::Model::Account
    account = Quickeebooks::Windows::Model::Account.new

    FakeWeb.register_uri(:post, @service.url_for_resource(model::REST_RESOURCE), :status => ["200", "OK"], :body => xml)

    account.name = "SampleAccount"
    account.active = true
    account.type = "Expense"
    account.sub_type = "Expense"
    account.acct_num = 111111
    account.should be_valid

    create_response = @service.create(account)
    create_response.success?.should == true
    create_response.success.request_name.should == "AccountAdd"
  end
end