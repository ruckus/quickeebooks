describe "Quickeebooks::Online::Model::CompanyMetaData" do

  it "parse company meta data from XML" do
    xml = onlineFixture("company_meta_data.xml")
    company_meta_data = Quickeebooks::Online::Model::CompanyMetaData.from_xml(xml)

    company_meta_data.external_realm_id.should be_nil

    company_meta_data.registered_company_name.should == "Bay Area landscape services"

    company_meta_data.industry_type.should == "Landscaping Services"

    company_meta_data.addresses.count.should == 2

    company_meta_data.addresses.first.line1.should == "2600 Service Street"

    company_meta_data.legal_address.line1.should == "2602 Service Street"

    company_meta_data.phone.free_form_number.should == "(669)111-2222"

    company_meta_data.emails.size.should == 2
    company_meta_data.emails.first.address.should == "john@bayarealandscapeservices.com"

    # Tag not supported yet in Quickeebooks::Online::Model::Email
    # company_meta_data.emails.first.tag.should == "COMPANY_EMAIL"
  end
end
