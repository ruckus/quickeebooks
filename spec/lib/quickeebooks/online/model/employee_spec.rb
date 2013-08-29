describe "Quickeebooks::Online::Model::Employee" do

  it "parse employee from XML" do
    xml = onlineFixture("employee.xml")
    employee = Quickeebooks::Online::Model::Employee.from_xml(xml)
    employee.sync_token.should == 0
    employee.name.should == "John Simpson"
    employee.meta_data.create_time.year.should == Date.civil(2010, 9, 10).year
    employee.addresses.count.should == 1
    employee.addresses.first.line1.should == "21215 Burbank Boulevard, Ste. 100"
    employee.phones.size.should == 2
    employee.phones.first.free_form_number.should == "(818) 936-7800"
    employee.email.address.should == "john.simpson@mint.com"
  end

  it "can assign an email address" do
    employee = Quickeebooks::Online::Model::Employee.new
    the_email = "foo@example.org"
    employee.email_address = the_email
    employee.email.is_a?(Quickeebooks::Online::Model::Email).should == true
    employee.email.address.should == the_email
  end

  it "cannot update an invalid model" do
    employee = Quickeebooks::Online::Model::Employee.new
    employee.to_xml_ns.should match('Employee')
    employee.valid_for_update?.should == false
    employee.errors.keys.include?(:sync_token).should == true
  end

end
