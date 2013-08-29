describe "Quickeebooks::Online::Service::Filter" do
  before(:all) do
  end

  it "can generate a text filter" do
    filter = Quickeebooks::Online::Service::Filter.new(:text, :field => "Name", :value => "Smith")
    filter.to_s.should == "Name :EQUALS: Smith"
  end

  it "can generate a boolean filter" do
    filter = Quickeebooks::Online::Service::Filter.new(:boolean, :field => "IncludeJobs", :value => false)
    filter.to_s.should == "IncludeJobs :EQUALS: false"
  end

  it "can generate a date filter" do
    date = Date.civil(2012, 2, 16)
    filter = Quickeebooks::Online::Service::Filter.new(:date, :field => "CreateTime", :value => date)
    filter.to_s.should == "CreateTime :EQUALS: 2012-02-16"
  end

  it "can generate a datetime filter" do
    time = Time.mktime(2012, 1, 2, 8, 31, 44)
    filter = Quickeebooks::Online::Service::Filter.new(:datetime, :field => "CreateTime", :after => time)
    filter.to_s.should == "CreateTime :AFTER: 2012-01-02T08:31:44UTC"
  end

  it "can generate a number filter with equals" do
    filter = Quickeebooks::Online::Service::Filter.new(:number, :field => "OpenBalance", :eq => 5)
    filter.to_s.should == "OpenBalance :EQUALS: 5"
  end

  it "can generate a number filter with greater than" do
    filter = Quickeebooks::Online::Service::Filter.new(:number, :field => "OpenBalance", :gt => 5)
    filter.to_s.should == "OpenBalance :GreaterThan: 5"
  end

  it "can generate a number filter with less than" do
    filter = Quickeebooks::Online::Service::Filter.new(:number, :field => "OpenBalance", :lt => 5)
    filter.to_s.should == "OpenBalance :LessThan: 5"
  end

  it "can generate a datetime filter with bounded dates" do
    time1 = Time.mktime(2012, 1, 2, 1)
    time2 = Time.mktime(2012, 1, 5, 8)
    filter = Quickeebooks::Online::Service::Filter.new(:datetime, :field => "CreateTime", :after => time1, :before => time2)
    # 'before' is checked before 'after' :)
    text = "CreateTime :BEFORE: #{time2.strftime(Quickeebooks::Online::Service::Filter::DATE_TIME_FORMAT)}"
    text = "#{text} :AND: CreateTime :AFTER: #{time1.strftime(Quickeebooks::Online::Service::Filter::DATE_TIME_FORMAT)}"
    filter.to_s.should == text
  end

end
