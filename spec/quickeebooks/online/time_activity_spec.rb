describe "Quickeebooks::Online::Model::TimeActivity" do

  describe "parse time_activity from XML" do
    xml = onlineFixture("time_activity.xml")
    time_activity = Quickeebooks::Online::Model::TimeActivity.from_xml(xml)
    time_activity.sync_token.should == 0
    time_activity.hours.should == 10
    time_activity.minutes.should == 5
    time_activity.billable_status.should == "Billable"
    time_activity.meta_data.create_time.year.should == Date.civil(2010, 9, 13).year
    time_activity.name_of.is_a?(Quickeebooks::Online::Model::TimeActivityVendor)
    time_activity.customer_id.should == "3794"
    time_activity.vendor.vendor_id.value.should == "3793"

  end


end
