describe Aldous::Service do
  before do
    class ExampleService
      include Aldous::Service

      def initialize(*args)
      end
    end
  end
  after do
    Object.send :remove_const, 'ExampleService'
  end

  describe '.build' do
    subject(:build) { ExampleService.build argument }
    let(:argument) { 'argument' }
    let(:service) { instance_double ExampleService }
    before do
      allow(ExampleService).to receive(:new) { service }
    end

    it 'instantiates a new service with arguments' do
      expect(ExampleService).to receive(:new).with(argument)
      build
    end

    it 'instantiates a service wrapper with service' do
      expect(Aldous::Service::Wrapper).to receive(:new).with(service)
      build
    end
  end

  describe '.perform' do
    subject(:perform) { ExampleService.perform argument }
    let(:argument) { 'argument' }
    let(:wrapper) { instance_double Aldous::Service::Wrapper, perform: result }
    let(:result) { Aldous::Result::Success.new }
    before do
      allow(ExampleService).to receive(:build) { wrapper }
    end

    it 'builds wrapper with arguments' do
      expect(ExampleService).to receive(:build).with(argument)
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

  describe '.perform!' do
    subject(:perform!) { ExampleService.perform! argument }
    let(:argument) { 'argument' }
    let(:wrapper) { instance_double Aldous::Service::Wrapper, perform!: result }
    let(:result) { Aldous::Result::Success.new }
    before do
      allow(ExampleService).to receive(:build) { wrapper }
    end

    it 'builds wrapper with arguments' do
      expect(ExampleService).to receive(:build).with(argument)
      perform!
    end

    it 'calls perform! on the wrapper' do
      expect(wrapper).to receive(:perform!)
      perform!
    end

    it 'returns result' do
      expect(perform!).to eq result
    end
  end

  describe '#perform' do
    let(:service) { ExampleService.new }
    subject(:perform) { service.perform }

    it 'raises a NotImplementedError' do
      expect { perform }.to raise_error(NotImplementedError, "ExampleService must implement method #perform")
    end
  end

  describe '#raisable_error' do
    let(:service) { ExampleService.new }
    subject(:raisable_error) { service.raisable_error }

    it 'defaults to Aldous::Errors::UserError' do
      expect(raisable_error).to eq Aldous::Errors::UserError
    end
  end

  describe '#default_result_options' do
    let(:service) { ExampleService.new }
    subject(:default_result_options) { service.default_result_options }

    it 'defaults to {}' do
      expect(default_result_options).to eq({})
    end
  end
end
