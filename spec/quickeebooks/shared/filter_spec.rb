describe "Quickeebooks::Shared::Service::Filter" do
  ENV['TZ'] = 'UTC'

  let(:filter){ Quickeebooks::Shared::Service::Filter }

  context 'DateTime' do
    describe '#to_s' do
      it 'parses after' do
        filter.new(:date,
          :field => 'Foo',
          :after => Date.parse('2020-12-31')).to_s.should == "Foo :AFTER: 2020-12-31"
      end

      it 'parses before' do
        filter.new(:date,
          :field => 'Foo',
          :before => Date.parse('2020-12-31')).to_s.should == "Foo :BEFORE: 2020-12-31"
      end

      it 'parses after with time' do
        filter.new(:datetime,
          :field => 'Foo',
          :after => DateTime.parse('2020-12-31T12:00:00')).to_s.should == "Foo :AFTER: 2020-12-31T12:00:00+00:00"
      end

      it 'parses before with time' do
        filter.new(:datetime,
          :field => 'Foo',
          :before => DateTime.parse('2020-12-31T12:00:00')).to_s.should == "Foo :BEFORE: 2020-12-31T12:00:00+00:00"
      end
    end

    context 'Time' do
      it 'parses after' do
        filter.new(:datetime,
          :field => 'Foo',
          :after => Time.parse('2020-12-31')).to_s.should == "Foo :AFTER: 2020-12-31T00:00:00UTC"
      end

      it 'parses before' do
        filter.new(:datetime,
          :field => 'Foo',
          :before => Time.parse('2020-12-31')).to_s.should == "Foo :BEFORE: 2020-12-31T00:00:00UTC"
      end

      it 'parses after with time' do
        filter.new(:datetime,
          :field => 'Foo',
          :after => Time.parse('2020-12-31 12:00:00')).to_s.should == "Foo :AFTER: 2020-12-31T12:00:00UTC"
      end

      it 'parses before with time' do
        filter.new(:datetime,
          :field => 'Foo',
          :before => Time.parse('2020-12-31 12:00:00')).to_s.should == "Foo :BEFORE: 2020-12-31T12:00:00UTC"
      end
    end

    context 'Not a date but responds to strftime' do
      before do
        # ActiveSupport::TimeWithZone is_a? Time but doesn't behave similarly.
        # This test lets us mock out that use case and verify it works
        @fake_time = mock(Object)
        @fake_time.stub(:is_a?).with(Time).and_return(true)
        @fake_time.stub(:is_a?).with(Date).and_return(false)
        @fake_time.stub(:strftime).and_return("2020-12-31T12:00:00")
      end

      it 'parses after' do
        filter.new(:datetime,
          :field => 'Foo',
          :after => @fake_time).to_s.should == "Foo :AFTER: 2020-12-31T12:00:00"
      end

      it 'parses before' do
        filter.new(:datetime,
          :field => 'Foo',
          :before => @fake_time).to_s.should == "Foo :BEFORE: 2020-12-31T12:00:00"
      end
    end

    describe '#to_xml' do
    end
  end

  context 'text' do
    describe '#to_s' do
      it 'parses text' do
        filter.new(:text,
          :field => 'Foo',
          :value => 'Bar').to_s.should == 'Foo :EQUALS: Bar'
      end
    end

    describe '#to_xml' do
      it 'parses text' do
        filter.new(:text,
          :field => 'Foo',
          :value => 'Bar').to_xml.should == '<Foo>Bar</Foo>'
      end

      it 'CGI escapes values' do
        filter.new(:text,
          :field => 'Foo',
          :value => "<3 Bar's ><things").to_xml.should == '<Foo>&lt;3 Bar\'s &gt;&lt;things</Foo>'
      end

      it 'CGI escapes integers' do
        filter.new(:text,
          :field => 'Foo',
          :value => 3).to_xml.should == '<Foo>3</Foo>'
      end
    end
  end

  context 'boolean' do
    describe '#to_s' do
      it 'parses boolean' do
        filter.new(:boolean,
          :field => 'Foo',
          :value => 'Bar').to_s.should == 'Foo :EQUALS: Bar'
      end
    end

    describe '#to_xml' do
      it 'parses boolean' do
        filter.new(:boolean,
          :field => 'Foo',
          :value => 'Bar').to_xml.should == '<Foo>Bar</Foo>'
      end
    end
  end

  context 'number' do
    describe '#to_s' do
      it 'parses eq' do
        filter.new(:number,
          :field => 'Foo',
          :eq    => 42).to_s.should == 'Foo :EQUALS: 42'
      end

      it 'parses lt' do
        filter.new(:number,
          :field => 'Foo',
          :lt    => 42).to_s.should == 'Foo :LessThan: 42'
      end

      it 'parses gt' do
        filter.new(:number,
          :field => 'Foo',
          :gt    => 42).to_s.should == 'Foo :GreaterThan: 42'
      end
    end

    describe '#to_xml' do
    end
  end

end