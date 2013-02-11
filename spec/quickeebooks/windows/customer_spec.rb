describe "Quickeebooks::Windows::Model::Customer" do

  it "parse customer from XML" do
    xml = windowsFixture("customer.xml")
    customer = Quickeebooks::Windows::Model::Customer.from_xml(xml)
    customer.sync_token.should == 1
    customer.name.should == "Wine House"

    customer.dba_name.should == "Wine House"

    create_time = Date.civil(2012, 3, 24)
    customer.meta_data.create_time.year.should == create_time.year
    customer.addresses.count.should == 1

    customer.addresses.first.line1.should == "Wine House"
    customer.addresses.first.line2.should == "2311 Maple Ave"

    customer.phones.size.should == 1
    customer.phones.first.free_form_number.should == "415-555-1212"

    customer.email.address.should == "no-reply@winehouse.com"

    customer.notes.count.should == 1
    customer.notes.first.content.should == "Likes chocolate and horses"

    customer.custom_fields.count.should == 0

    customer.open_balance.amount.should == 6200.0
  end

  it "can assign an email address" do
    customer = Quickeebooks::Windows::Model::Customer.new
    the_email = "foo@example.org"
    customer.email_address = the_email
    customer.email.is_a?(Quickeebooks::Windows::Model::Email).should == true
    customer.email.address.should == the_email
  end

  it "cannot update an invalid model" do
    customer = Quickeebooks::Windows::Model::Customer.new
    customer.valid_for_update?.should == false
    customer.errors.keys.include?(:sync_token).should == true
  end

end