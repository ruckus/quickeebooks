describe "Quickeebooks::Online::Model::JournalEntry" do
  it "parse invoice from XML" do
    xml = onlineFixture("journal_entry.xml")
    journal_entry = Quickeebooks::Online::Model::JournalEntry.from_xml(xml)
    journal_entry.id.value.should == "381"
    journal_entry.sync_token.should == 0
    journal_entry.header.doc_number.should == "5"
    journal_entry.header.msg.should == "Message about entry"
    journal_entry.header.note.should == "Some note"

    credit_li = journal_entry.line_items.select { |l| l.posting_type == "Credit" }.first
    credit_li.amount.should == 100.00
    credit_li.desc.should == "credit this -- Desc"
    credit_li.account_id.value.should == "255"
    credit_li.entity_id.value.should == "259"
    credit_li.entity_type.should == "Customer"

    debit_li = journal_entry.line_items.select { |l| l.posting_type == "Debit" }.first
    debit_li.amount.should == 100.00
    debit_li.desc.should == "debit this -- Desc"
    debit_li.account_id.value.should == "255"
    debit_li.entity_id.value.should == "260"
    debit_li.entity_type.should == "Customer"
  end

end
