describe "Quickeebooks::Shared::Service::Filter" do
  let(:sort_filter){Quickeebooks::Shared::Service::Sort}

  context '#to_s' do
    it "can generate a sorting parameter" do
      filter = sort_filter.new("FirstName", "NewestToOldest")
      filter.to_s.should == "FirstName NewestToOldest"
    end
  end

  context '#to_xml' do
    it "can generate a sorting parameter" do
      filter = sort_filter.new("FirstName", "Ascending")
      filter.to_xml.should == "<SortByColumn sortOrder=\"Ascending\">FirstName</SortByColumn>"
    end
  end
end