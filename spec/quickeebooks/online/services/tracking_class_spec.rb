describe Quickeebooks::Online::Service::TrackingClass do
  before(:all) do
    construct_online_service :tracking_class
  end

  describe ".list" do
    before(:each) do
      xml = onlineFixture("tracking_classes.xml")
      url = @service.url_for_resource(Quickeebooks::Online::Model::TrackingClass.resource_for_collection)
      FakeWeb.register_uri(:post, url, :status => ["200", "OK"], :body => xml)
    end

    subject { @service.list }

    it { subject.count.should == 2 }
    it { subject.entries.count.should == 2 }
    it { subject.entries[0].id.value.should == '1' }

  end

  describe ".create" do
    before(:each) do
      xml = onlineFixture("tracking_class.xml")
      url = @service.url_for_resource(Quickeebooks::Online::Model::TrackingClass.resource_for_singular)
      FakeWeb.register_uri(:post, url, :status => ["200", "OK"], :body => xml)

      @tracking_class = Quickeebooks::Online::Model::TrackingClass.new

      @tracking_class.name = "2012-11-02"
      @tracking_class.class_parent_id = Quickeebooks::Online::Model::Id.new("3000000000000040889")
    end

    subject { @service.create(@tracking_class) }

    it { subject.id.value.should == "3000000000000029839" }
  end

  describe ".delete" do
    before(:each) do
      @tracking_class_id = "3000000000000029839"
      url = @service.url_for_resource(Quickeebooks::Online::Model::TrackingClass.resource_for_singular)
      url += "/#{@tracking_class_id}?methodx=delete"
      FakeWeb.register_uri(:post, url, :status => ["200", "OK"])

      @tracking_class = Quickeebooks::Online::Model::TrackingClass.new

      @tracking_class.id = Quickeebooks::Online::Model::Id.new(@tracking_class_id)
      @tracking_class.name = "2012-11-02"
      @tracking_class.sync_token = 0
    end

    subject { @service.delete @tracking_class }

    it { should be_true }

  end

  describe ".fetch_by_id" do
    before(:each) do
      @tracking_class_id = "3000000000000029839"
      xml = onlineFixture("tracking_class.xml")
      url = @service.url_for_resource(Quickeebooks::Online::Model::TrackingClass.resource_for_singular)
      url += "/#{@tracking_class_id}"
      FakeWeb.register_uri(:get, url, :status => ["200", "OK"], :body => xml)
    end

    subject { @service.fetch_by_id(3000000000000029839) }

    it { should be_kind_of(Quickeebooks::Online::Model::TrackingClass) }
    it { subject.name.should == "2012-11-02" }
    it { subject.id.value.should == @tracking_class_id }
    it { subject.class_parent_id.value.should == "3000000000000040889" }
  end

  describe ".update" do
    before(:each) do
      @tracking_class_id = "3000000000000029839"
      xml = onlineFixture("tracking_class_updated.xml")
      url = @service.url_for_resource(Quickeebooks::Online::Model::TrackingClass.resource_for_singular)
      url += "/#{@tracking_class_id}"
      FakeWeb.register_uri(:post, url, :status => ["200", "OK"], :body => xml)

      @tracking_class = Quickeebooks::Online::Model::TrackingClass.new
      @tracking_class.id = Quickeebooks::Online::Model::Id.new(@tracking_class_id)
      @tracking_class.name = "2013-11-02"
      @tracking_class.class_parent_id = Quickeebooks::Online::Model::Id.new("3000000000000040889")
      @tracking_class.sync_token = 1
    end

    subject { @service.update(@tracking_class) }

    it { should be_kind_of(Quickeebooks::Online::Model::TrackingClass) }
    it { subject.name.should == @tracking_class.name }
    it { subject.id.value.should == @tracking_class.id.value }
    it { subject.class_parent_id.value.should == @tracking_class.class_parent_id.value }

  end
end
