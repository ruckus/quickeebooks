describe "Quickeebooks::Online::Model::Vendor" do

  it "parse vendor from XML" do
    xml = onlineFixture("vendor.xml")
    vendor = Quickeebooks::Online::Model::Vendor.from_xml(xml)
    vendor.sync_token.should == 0
    vendor.name.should == "Digital"
    vendor.meta_data.create_time.year.should == Date.civil(2010, 9, 13).year
    vendor.addresses.count.should == 1
    vendor.addresses.first.line1.should == "Park Avenue"
    vendor.phones.size.should == 1
    vendor.phones.first.free_form_number.should == "(818) 436-8225"
    vendor.email.address.should == "john_doe@digitalinsight.mint.com"
    vendor.open_balance.amount.should == 6200.0
    vendor.is_1099?.should == true
  end

  it "can assign an email address" do
    vendor = Quickeebooks::Online::Model::Vendor.new
    the_email = "foo@example.org"
    vendor.email_address = the_email
    vendor.email.is_a?(Quickeebooks::Online::Model::Email).should == true
    vendor.email.address.should == the_email
  end

  it "cannot update an invalid model" do
    vendor = Quickeebooks::Online::Model::Vendor.new
    vendor.to_xml_ns.should match('Vendor')
    vendor.valid_for_update?.should == false
    vendor.errors.keys.include?(:sync_token).should == true
  end

end
