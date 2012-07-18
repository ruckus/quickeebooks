require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require "quickeebooks"

describe Quickeebooks do

  describe "VERSION" do
    subject { Quickeebooks::VERSION }
    it { should be_a String }
  end

end
