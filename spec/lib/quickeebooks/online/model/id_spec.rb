describe "Quickeebooks::Online::Model::Id" do

  it "can be converted to String" do
    id = Quickeebooks::Online::Model::Id.new(42)
    id.to_s.should == "42"
  end

  it "can be converted to Integer" do
    id = Quickeebooks::Online::Model::Id.new(42)
    id.to_i.should == 42
  end

  it "can be coerced into a String" do
    id = Quickeebooks::Online::Model::Id.new(42)
    "/whatever/#{id}".should == "/whatever/42"
  end

end
