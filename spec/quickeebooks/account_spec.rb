require "spec_helper"

require "quickeebooks/model/account"

describe "Quickeebooks::Model::Account" do
  
  it "should convert Ruby to XML" do
    account = Quickeebooks::Model::Account.new
    account.sync_token = 1
    account.name = "John Doe"
    puts account.to_xml(:fields => 'Name')
    #puts account.name.inspect
  end
  
end