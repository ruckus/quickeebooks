describe 'Mixin CRUD like methods for various service modules' do

  context "validations" do
    it "outputs the erros" do
      service = Quickeebooks::Online::Service::Invoice.new
      expect {
        service.create(Quickeebooks::Online::Model::Invoice.new)
      }.to raise_error(InvalidModelException, /Line items is too short/)
    end
  end
  context 'model method' do
    it 'should constantize properly for an online service' do
      service = Quickeebooks::Online::Service::Bill.new
      service.model.should be_a(Class)
      service.model.to_s.should == "Quickeebooks::Online::Model::Bill"
    end

    it 'should constantize properly for a windows service' do
      expect {
        # Test build_dummy first
        build_dummy_windows_service
        Quickeebooks::Windows::Service::TEST.new.model
      }.to raise_exception NoMethodError

      build_dummy_windows_service('include ServiceCRUD')
      service = Quickeebooks::Windows::Service::TEST.new
      service.model.should be_a(Class)
      service.model.to_s.should == "Quickeebooks::Windows::Model::TEST"
    end

    def build_dummy_windows_service(inc = '')
      eval("
        module Quickeebooks
          module Windows
            module Service
              class TEST < Quickeebooks::Windows::Service::ServiceBase
                #{inc}
              end
            end
            module Model
              class TEST < Quickeebooks::Windows::Model::IntuitType
              end
            end
          end
        end
      ", TOPLEVEL_BINDING)
    end
  end
end
