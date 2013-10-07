describe "Quickeebooks::Online::Model::Account" do

  it "should convert Ruby to XML" do
    account = Quickeebooks::Online::Model::Account.new
    account.sync_token = 1
    account.name = "John Doe"
    expected = "<Account><Name>John Doe</Name></Account>"
    # we have to jump through some hoops to get a non-pretty version for easier comparison
    s = StringIO.new
    xml = account.to_xml(:fields => 'Name').write_to(s, :indent => 0, :indent_text => '')
    xml.string.gsub(/\n/, '').should == expected
  end

  it "has a validation error on invalid subtype" do
    account = Quickeebooks::Online::Model::Account.new
    account.sub_type = "invalid"
    account.valid?.should == false
  end

  it "has a validation error when required attributes are not given" do
    account = Quickeebooks::Online::Model::Account.new
    account.valid?.should == false
  end

  it "should pass validation when all required attributes are given" do
    account = Quickeebooks::Online::Model::Account.new
    account.name = "John Doe"
    account.sub_type = "AccountsPayable"
    account.valid?.should == true
  end

  it "cannot delete an Account without providing required fields" do
    account = Quickeebooks::Online::Model::Account.new
    account.valid_for_deletion?.should == false
  end

end