describe "Quickeebooks::Online::Model::Item" do

  it "returns pluralized resource for collection" do
    Quickeebooks::Online::Model::Item.resource_for_collection.should == 'items'
  end

  it "returns single resource for singular " do
    Quickeebooks::Online::Model::Item.resource_for_singular.should == 'item'
  end

end