RSpec.describe Aldous::Conductor do

  let(:conductor) { described_class.new(controller, mapping) }
  let(:perform)   { conductor.perform(*args) }
  let(:args)      do
    [
      :arg_one,
      :arg_two, {
        key: :value
      }
    ]
  end

  let(:controller) {
    double "controller", params: {
      id:    123,
      class: controller_class,
      action: double('example', {classify: 'Example'})
    }
  }

  let!(:controller_class) do
    Object.const_set('ExampleControllerClass', Class.new)
  end

  let!(:controller_service_class) do
    controller_class.const_set('ExampleService', Class.new)
  end

  let(:controller_service) do
    double 'controller_service', perform: result
  end

  let(:result) do
    double 'result'
  end

  let(:mapping) do
    {
      String => Object,
    }
  end

  #
  #
  #

  before do
    allow(controller).to receive(:class).and_return(controller_class)
    allow(controller_service_class).to receive(:new).and_return(controller_service)
    allow(Aldous::ResultDispatcher).to receive(:execute)
  end

  describe "#perform" do

    it 'builds a controller service by inspecting params[:action]' do
      expect(ExampleControllerClass::ExampleService).to receive(:new)
      perform
    end

    it 'sends its splatted args to #perform on the service' do
      expect(ExampleControllerClass::ExampleService).to receive(:new).with(*args)
      perform
    end

    describe 'with a valid mapping' do
      it 'calls #perform on the service and store the result' do
        expect(controller_service).to receive(:perform)
        perform
        expect(conductor.result).to eq result
      end

      it 'calls Aldous::ResultDispatcher.execute with controller, result, mapping' do
        expect(Aldous::ResultDispatcher).to receive(:execute).with(controller, result, mapping)
        perform
      end
    end
  end

end