describe "Quickeebooks::Online::Model::Customer" do

  it "parse customer from XML" do
    xml = onlineFixture("customer.xml")
    customer = Quickeebooks::Online::Model::Customer.from_xml(xml)
    customer.sync_token.should == 1
    customer.name.should == "John Doe"

    create_time = Date.civil(2011, 9, 29)
    customer.meta_data.create_time.year.should == create_time.year
    customer.addresses.count.should == 2

    customer.billing_address.line1.should == "123 Main St."
    customer.shipping_address.line1.should == "123 Shipping St."

    customer.phones.size.should == 5
    customer.primary_phone.free_form_number.should == "(408) 555-1212"
    customer.secondary_phone.free_form_number.should == "(408) 555-1213"
    customer.mobile_phone.free_form_number.should == "(408) 555-1214"
    customer.fax.free_form_number.should == "(408) 555-1215"
    customer.pager.free_form_number.should == "(408) 555-1216"

    customer.email.address.should == "johndoe@gmail.com"

    customer.notes.count.should == 1
    customer.notes.first.content.should == "Likes chocolate and horses"

    customer.custom_fields.count.should == 3

    customer.open_balance.amount.should == 6200.0
  end

  it "can assign an email address" do
    customer = Quickeebooks::Online::Model::Customer.new
    the_email = "foo@example.org"
    customer.email_address = the_email
    customer.email.is_a?(Quickeebooks::Online::Model::Email).should == true
    customer.email.address.should == the_email
  end

  it "cannot update an invalid model" do
    customer = Quickeebooks::Online::Model::Customer.new
    customer.valid_for_update?.should == false
    customer.to_xml_ns.should match('Customer')
    customer.errors.keys.include?(:sync_token).should == true
  end

end
