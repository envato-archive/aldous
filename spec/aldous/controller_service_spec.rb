describe Aldous::ControllerService do
  before do
    class ExampleControllerService
      include Aldous::ControllerService

      def initialize(*args)
      end
    end
  end
  after do
    Object.send :remove_const, 'ExampleControllerService'
  end

  describe '.build' do
    subject(:build) { ExampleControllerService.build argument }
    let(:argument) { 'argument' }
    let(:controller_service) { instance_double ExampleControllerService }
    before do
      allow(ExampleControllerService).to receive(:new) { controller_service }
    end

    it 'instantiates a new controller_service with arguments' do
      expect(ExampleControllerService).to receive(:new).with(argument)
      build
    end

    it 'instantiates a controller_service wrapper with controller_service' do
      expect(Aldous::ControllerService::Wrapper).to receive(:new).with(controller_service)
      build
    end
  end

  describe '.perform' do
    subject(:perform) { ExampleControllerService.perform argument }
    let(:argument) { 'argument' }
    let(:wrapper) { instance_double Aldous::ControllerService::Wrapper, perform: result }
    let(:result) { Aldous::Result::Success.new }
    before do
      allow(ExampleControllerService).to receive(:build) { wrapper }
    end

    it 'builds wrapper with arguments' do
      expect(ExampleControllerService).to receive(:build).with(argument)
      perform
    end

    it 'calls perform on the wrapper' do
      expect(wrapper).to receive(:perform)
      perform
    end

    it 'returns result' do
      expect(perform).to eq result
    end
  end

  describe '#perform' do
    let(:controller_service) { ExampleControllerService.new }
    subject(:perform) { controller_service.perform }

    it 'raises a NotImplementedError' do
      expect { perform }.to raise_error(NotImplementedError, "ExampleControllerService must implement method #perform")
    end
  end

  describe '#default_result_options' do
    let(:controller_service) { ExampleControllerService.new }
    subject(:default_result_options) { controller_service.default_result_options }

    it 'defaults to {}' do
      expect(default_result_options).to eq({})
    end
  end

  describe '#preconditions' do
    let(:controller_service) { ExampleControllerService.new }
    subject(:preconditions) { controller_service.preconditions }

    it 'defaults to []]' do
      expect(preconditions).to eq([])
    end
  end
end
