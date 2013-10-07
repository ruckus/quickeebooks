describe "Quickeebooks::Online::Service::JournalEntry" do
  before(:all) do
    construct_online_service :journal_entry
  end

  it "can fetch a list of journal entries" do
    xml = onlineFixture("journal_entries.xml")
    url = @service.url_for_resource(Quickeebooks::Online::Model::JournalEntry.resource_for_collection)
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"], :body => xml)
    journal_entries = @service.list
    journal_entries.current_page.should == 1
    journal_entries.entries.count.should == 1
  end

  it "can create a journal entry" do
    xml = onlineFixture("journal_entry.xml")
    url = @service.url_for_resource(Quickeebooks::Online::Model::JournalEntry.resource_for_singular)
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"], :body => xml)
    journal_entry = Quickeebooks::Online::Model::JournalEntry.new
    journal_entry.header = Quickeebooks::Online::Model::JournalEntryHeader.new
    journal_entry.header.note = "Journal entry for bananas"
    journal_entry.header.doc_number = "5"

    credit = Quickeebooks::Online::Model::JournalEntryLineItem.new
    credit.amount = 100.00
    credit.posting_type = "Credit"
    credit.account_id = Quickeebooks::Online::Model::Id.new("255")
    credit.entity_id = Quickeebooks::Online::Model::Id.new("259")
    journal_entry.line_items << credit

    debit = Quickeebooks::Online::Model::JournalEntryLineItem.new
    debit.amount = 100.00
    debit.posting_type = "Debit"
    debit.account_id = Quickeebooks::Online::Model::Id.new("255")
    debit.entity_id = Quickeebooks::Online::Model::Id.new("259")
    journal_entry.line_items << debit

    result = @service.create(journal_entry)
    result.id.value.to_i.should > 0
  end

  it "can delete a journal entry" do
    url = "#{@service.url_for_resource(Quickeebooks::Online::Model::JournalEntry.resource_for_singular)}/5?methodx=delete"
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"])
    journal_entry = Quickeebooks::Online::Model::JournalEntry.new
    journal_entry.id = Quickeebooks::Online::Model::Id.new("5")
    journal_entry.sync_token = 0
    result = @service.delete(journal_entry)
    result.should == true
  end

  it "can fetch a journal entry by id" do
    xml = onlineFixture("journal_entry.xml")
    url = "#{@service.url_for_resource(Quickeebooks::Online::Model::JournalEntry.resource_for_singular)}/47"
    FakeWeb.register_uri(:get, url, :status => ["200", "OK"], :body => xml)
    journal_entry = @service.fetch_by_id(47)
    journal_entry.header.doc_number.should == "5"
  end

  it "can update a journal entry" do
    xml2 = onlineFixture("journal_entry2.xml")
    journal_entry = Quickeebooks::Online::Model::JournalEntry.new
    journal_entry.header = Quickeebooks::Online::Model::JournalEntryHeader.new
    journal_entry.header.note = "Updated note for journal entry"
    journal_entry.id = Quickeebooks::Online::Model::Id.new("50")
    journal_entry.sync_token = 2

    url = "#{@service.url_for_resource(Quickeebooks::Online::Model::JournalEntry.resource_for_singular)}/#{journal_entry.id.value}"
    FakeWeb.register_uri(:post, url, :status => ["200", "OK"], :body => xml2)
    updated = @service.update(journal_entry)
  end

end
