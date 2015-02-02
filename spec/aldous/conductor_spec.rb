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

  let(:controller_service) do
    double 'controller_service', perform: result, preconditions: preconditions
  end

  let(:result) do
    double 'result'
  end

  let(:mapping) do
    {
      String => Object,
    }
  end

  let(:preconditions) { [] }

  #
  # define fake classes
  #

  let!(:controller_class) do
    if defined? ExampleControllerClass
      ExampleControllerClass
    else
      Object.const_set('ExampleControllerClass', Class.new)
    end
  end

  let!(:controller_service_class) do
    if defined? ExampleControllerClass::ExampleService
      ExampleControllerClass::ExampleService
    else
      controller_class.const_set('ExampleService', Class.new)
    end
  end

  let!(:precondition_class) do
    if defined? ExampleControllerClass::ExamplePrecondition
      ExampleControllerClass::ExamplePrecondition
    else
      controller_class.const_set('ExamplePrecondition', Class.new).instance_eval do
        include Aldous::ControllerService::Precondition
      end
    end
  end

  after do
    # clean up object space
    Object.send :remove_const, 'ExampleControllerClass'
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

    describe 'mapping contains a non-class key' do
      let(:mapping) { { oops: String } }

      it 'raises ArgumentError' do
        expect { perform }.to raise_error(ArgumentError)
      end
    end

    describe 'mapping contains a non-class value' do
      let(:mapping) { { String => :oops } }

      it 'raises ArgumentError' do
        expect { perform }.to raise_error(ArgumentError)
      end
    end

    describe 'with preconditions' do

      let(:preconditions) do
        [precondition_class.new]
      end

      context 'when precondition failures are all mapped' do
        let(:mapping) do
          {
            ExampleControllerClass::ExamplePrecondition::Failure => String,
          }
        end

        it 'calls Aldous::ResultDispatcher.execute with controller, result, mapping' do
          expect(Aldous::ResultDispatcher).to receive(:execute).with(controller, result, mapping)
          perform
        end
      end

      context 'when precondition failures are absent from mapping' do
        let(:mapping) {{}}

        it 'raises MissingPreconditionFailureMappingError' do
          expect { perform }.to raise_error Aldous::Conductor::MissingPreconditionFailureMappingError
        end
      end
    end
  end

end