describe Quickeebooks do

  describe "VERSION" do
    subject { Quickeebooks::VERSION }
    it { should be_a String }
  end

  describe "Result Format" do
    it "can set result format as :hash" do
      Quickeebooks.result_format = :hash
      Quickeebooks.result_format.should == :hash
      Quickeebooks.hash_result_format?.should == true
      Quickeebooks.object_result_format?.should == false
    end

    it "can set result format as :object" do
      Quickeebooks.result_format = 'Object'
      Quickeebooks.result_format.should == :object
      Quickeebooks.hash_result_format?.should == false
      Quickeebooks.object_result_format?.should == true
    end
  end
end

