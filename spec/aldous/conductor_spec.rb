RSpec.describe Aldous::Conductor do
  let(:conductor) { described_class.new(controller, mapping) }
  let(:perform) { conductor.perform(*args) }
  let(:args) do
    [
      :arg_one,
      :arg_two, {
        key: :value
      }
    ]
  end
  let(:controller) {
    double "controller", params: {
        id:     123,
        action: double('example', { classify: 'Example' })
      }
  }
  let(:controller_service) do
    double 'controller_service', perform: result, preconditions: preconditions
  end
  let(:result) { double 'result' }
  let(:mapping) { { String => Object } }
  let(:preconditions) { [] }
  before do
    class ExampleControllerClass
      class ExampleService
        include Aldous::ControllerService
      end

      class ExamplePrecondition
        include Aldous::ControllerService::Precondition
      end
    end

    allow(controller).to receive(:class) { ExampleControllerClass }
    allow(ExampleControllerClass::ExampleService).to receive(:build) { controller_service }
    allow(Aldous::ResultDispatcher).to receive(:execute)
  end
  after do
    Object.send :remove_const, 'ExampleControllerClass'
  end

  describe '#perform' do

    it 'builds a controller service by inspecting params[:action]' do
      expect(ExampleControllerClass::ExampleService).to receive(:build)
      perform
    end

    it 'sends its splatted args to #perform on the service' do
      expect(ExampleControllerClass::ExampleService).to receive(:build).with(*args)
      perform
    end

    describe 'with a valid mapping' do
      it 'calls #perform on the service' do
        expect(controller_service).to receive(:perform)
        perform
      end

      it 'returns the service result' do
        expect(perform).to eq result
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
        [ExampleControllerClass::ExamplePrecondition.new]
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
        let(:mapping) { {} }

        it 'raises MissingPreconditionFailureMappingError' do
          expect { perform }.to raise_error Aldous::Conductor::MissingPreconditionFailureMappingError
        end
      end
    end
  end

end
