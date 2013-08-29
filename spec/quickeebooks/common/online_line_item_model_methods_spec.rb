describe 'Mixin for online models that have line items' do

  let (:shared_models) { %w(Invoice Payment Bill) }

  it 'initializes' do
    shared_models.each do |model|
      klass = "Quickeebooks::Online::Model::#{model}".constantize
      klass.new.line_items.size == 0
      xml = onlineFixture("#{model.downcase}.xml")
      klass.from_xml(xml).line_items.size.should == 1
    end
  end

  it 'references constants' do
    shared_models.each do |model|
      klass = "Quickeebooks::Online::Model::#{model}".constantize
      klass.resource_for_collection.should == "#{model.downcase}s"
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
      xml = onlineFixture("#{model.downcase}.xml")
      item = klass.from_xml(xml)
      item.valid_for_deletion?.should be_true
    end
  end

end
