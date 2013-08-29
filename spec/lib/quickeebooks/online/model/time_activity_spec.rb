describe "Quickeebooks::Online::Model::TimeActivity" do

  it "parse time_activity from XML" do
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

  describe 'validations' do
    describe 'duration' do
      it 'is not valid if no duration is provided' do
        time_activity = Quickeebooks::Online::Model::TimeActivity.new
        time_activity.valid?
        time_activity.errors.full_messages.should include('A duration is required')
      end

      it 'is not valid when hours/minutes and start_time/end_time are both set' do
        time_activity = Quickeebooks::Online::Model::TimeActivity.new
        time_activity.hours = 2
        time_activity.minutes = 12
        time_activity.start_time = Time.now - (30 * 60) # 30 minutes ago
        time_activity.end_time = Time.now + (30 * 60) # 30 minutes from now
        time_activity.valid?
        time_activity.errors.full_messages.should include('Only one duration type allowed')
      end

      it 'is valid when hours/minutes is provided' do
        time_activity = Quickeebooks::Online::Model::TimeActivity.new
        time_activity.hours = 2
        time_activity.minutes = 12
        time_activity.valid?
        time_activity.errors.full_messages.should_not include('A duration is required')
      end

      it 'is valid when start_time/end_time is provided' do
        time_activity = Quickeebooks::Online::Model::TimeActivity.new
        time_activity.start_time = Time.now - (30 * 60) # 30 minutes ago
        time_activity.end_time = Time.now + (30 * 60) # 30 minutes from now
        time_activity.valid?
        time_activity.errors.full_messages.should_not include('A duration is required')
      end
    end
    describe 'name_of' do
      it 'is valid when set to Employee' do
        time_activity = Quickeebooks::Online::Model::TimeActivity.new
        time_activity.name_of = 'Employee'
        time_activity.valid?
        time_activity.errors.messages.keys.should_not include(:name_of)
      end

      it 'is valid when set to Vendor' do
        time_activity = Quickeebooks::Online::Model::TimeActivity.new
        time_activity.name_of = 'Vendor'
        time_activity.valid?
        time_activity.errors.messages.keys.should_not include(:name_of)
      end

      it 'is not valid when not provided' do
        time_activity = Quickeebooks::Online::Model::TimeActivity.new
        time_activity.valid?
        time_activity.errors.full_messages.should include('Name of is not included in the list')
      end
    end
    describe 'customer_id' do
      it 'is valid when billable_status is Billable' do
        time_activity = Quickeebooks::Online::Model::TimeActivity.new
        time_activity.billable_status = 'Billable'
        time_activity.customer_id = 5
        time_activity.valid?
        time_activity.errors.messages.keys.should_not include(:customer_id)
      end

      it 'is required when billable_status is Billable' do
        time_activity = Quickeebooks::Online::Model::TimeActivity.new
        time_activity.billable_status = 'Billable'
        time_activity.valid?
        time_activity.errors.full_messages.should include("Customer can't be blank")
      end

      it 'is not required when billable_status is not Billable' do
        time_activity = Quickeebooks::Online::Model::TimeActivity.new
        time_activity.billable_status = 'NotBillable'
        time_activity.valid?
        time_activity.errors.messages.keys.should_not include(:customer_id)
      end
    end
    describe 'hourly_rate' do
      it 'is valid when billable_status is Billable' do
        time_activity = Quickeebooks::Online::Model::TimeActivity.new
        time_activity.billable_status = 'Billable'
        time_activity.hourly_rate = 5
        time_activity.valid?
        time_activity.errors.messages.keys.should_not include(:hourly_rate)
      end

      it 'is required when billable_status is Billable' do
        time_activity = Quickeebooks::Online::Model::TimeActivity.new
        time_activity.billable_status = 'Billable'
        time_activity.valid?
        time_activity.errors.full_messages.should include("Hourly rate can't be blank")
      end

      it 'is not required when billable_status is not Billable' do
        time_activity = Quickeebooks::Online::Model::TimeActivity.new
        time_activity.billable_status = 'NotBillable'
        time_activity.valid?
        time_activity.errors.messages.keys.should_not include(:hourly_rate)
      end
    end
    describe 'billable_status' do
      %w(Billable NotBillable HasBeenBilled).each do |status|
        it "is valid with status #{status}" do
          time_activity = Quickeebooks::Online::Model::TimeActivity.new
          time_activity.billable_status = status
          time_activity.valid?
          time_activity.errors.messages.keys.should_not include(:billable_status)
        end
      end

      it 'is invalid with unknown status' do
        time_activity = Quickeebooks::Online::Model::TimeActivity.new
        time_activity.billable_status = 'FooBarBaz'
        time_activity.valid?
        time_activity.errors.full_messages.should include('Billable status is not included in the list')
      end

      it 'is valid when not set' do
        time_activity = Quickeebooks::Online::Model::TimeActivity.new
        time_activity.valid?
        time_activity.errors.messages.keys.should_not include(:billable_status)
      end
    end
  end

end
