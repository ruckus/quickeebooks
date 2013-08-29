describe "Quickeebooks::Online::Model::TrackingClass" do
  it { Quickeebooks::Online::Model::TrackingClass.resource_for_singular.should == "class" }
  it { Quickeebooks::Online::Model::TrackingClass.resource_for_collection.should == "classes" }

  describe "#from_xml" do
    describe "parse tracking class from XML" do
      let(:tracking_class){ Quickeebooks::Online::Model::TrackingClass.from_xml(onlineFixture("tracking_class.xml")) }

      it{ tracking_class.should be_a Quickeebooks::Online::Model::TrackingClass }
      it{ tracking_class.id.value.should == "3000000000000029839" }
      it{ tracking_class.sync_token.should == 0 }
      it{ tracking_class.name.should == "2012-11-02" }
      it{ tracking_class.class_parent_id == "3000000000000040889" }
      it{ tracking_class.meta_data.create_time == Time.parse("2012-11-15T12:39:48-08:00") }
      it{ tracking_class.meta_data.last_updated_time == Time.parse("2013-03-29T09:26:54-07:00") }
    end
  end

  describe ".to_xml_ns" do

    let(:tracking_class) {
      tracking_class = Quickeebooks::Online::Model::TrackingClass.new
      tracking_class.name = "2013-06-21"
      tracking_class.class_parent_id = Quickeebooks::Online::Model::Id.new('3000000000000040634')
      tracking_class
    }

    subject { tracking_class.to_xml_ns }

    it { should match("<Class xmlns:ns2=\"http://www.intuit.com/sb/cdm/qbo\" xmlns=\"http://www.intuit.com/sb/cdm/v2\" xmlns:ns3=\"http://www.intuit.com/sb/cdm\">\n<Name>2013-06-21</Name>\n<ClassParentId>3000000000000040634</ClassParentId>\n</Class>") }
  end
end