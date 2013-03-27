describe 'Mixin for online models that have line items' do

  let (:shared_models) { %w(Invoice Payment Bill JournalEntry SalesReceipt) }

  it 'initializes' do
    shared_models.each do |model|
      klass = "Quickeebooks::Online::Model::#{model}".constantize
      klass.new.line_items.size == 0
      xml = onlineFixture("#{model.underscore}.xml")
      count = model == "JournalEntry" ? 2 : 1
      klass.from_xml(xml).line_items.size.should == count
    end
  end

  it 'references constants' do
    shared_models.each do |model|
      klass = "Quickeebooks::Online::Model::#{model}".constantize
      klass.resource_for_collection.should == model.underscore.dasherize.pluralize
      klass.new.to_xml_ns.should == "<#{model}/>"
    end
  end

  it 'valid for updates' do
    shared_models.each do |model|
      klass = "Quickeebooks::Online::Model::#{model}".constantize.new
      klass.valid_for_update?.should be_true
      klass.errors.add(:id, 'no user')
      klass.valid_for_update?.should be_false
    end
  end

  it 'valid for deletion' do
    shared_models.each do |model|
      klass = "Quickeebooks::Online::Model::#{model}".constantize
      xml = onlineFixture("#{model.underscore}.xml")
      item = klass.from_xml(xml)
      item.valid_for_deletion?.should be_true
    end
  end

end

