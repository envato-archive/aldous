RSpec.describe Aldous::Service::Wrapper do
  let(:wrapper) { described_class.new service }

  let(:service) { double 'service', perform: service_result, default_result_data: default_result_data, raisable_error: raisable_error }
  let(:service_result) { Aldous::Service::Result::Success.new service_result_data }
  let(:default_result_data) { { default_result_data: true } }
  let(:service_result_data) { { service_result_data: true } }
  let(:raisable_error) { Aldous::Errors::UserError }

  before do
    allow(Aldous.config.error_reporter).to receive(:report)
  end

  describe '#perform!' do
    subject(:perform!) { wrapper.perform! }

    it 'calls perform on the service' do
      expect(service).to receive(:perform)
      perform!
    end

    it 'returns a result of same type as result returned by service' do
      expect(perform!.class).to be service_result.class
    end

    it 'includes default result data in result' do
      expect(perform!.default_result_data).to eq true
    end

    it 'includes service result data in result' do
      expect(perform!.service_result_data).to eq true
    end

    context 'when service returns a value that is not an Aldous result' do
      let(:service_result) { 'uh oh' }

      it 'raises raisable error' do
        expect { perform! }.to raise_error(raisable_error, "Return value of #perform must be a type of #{::Aldous::Service::Result::Base}")
      end
    end

    context 'when service raises an error' do
      let(:e) { StandardError.new 'message' }

      before do
        allow(service).to receive(:perform).and_raise(e)
      end

      it 'raises raisable error with original error message' do
        expect { perform! }.to raise_error(raisable_error, e.message)
      end
    end
  end

  describe '#perform' do
    subject(:perform) { wrapper.perform }

    before do
      Aldous.configuration.logger = Aldous::DummyLogger
    end

    context 'when perform! does not raise an error' do
      let(:result) { Aldous::Service::Result::Success.new }
      before do
        allow(wrapper).to receive(:perform!) { result }
      end

      it 'returns the result' do
        expect(perform).to eq result
      end
    end

    context 'when perform! raises an error' do
      let(:e) { raisable_error.new }

      before do
        allow(wrapper).to receive(:perform!).and_raise(e)
      end

      it 'returns a failure result' do
        expect(perform).to be_failure
      end

      it 'includes default result data in result' do
        expect(perform.default_result_data).to eq true
      end

      it 'includes error in result' do
        expect(perform.errors).to eq [e]
      end

      it 'reports the error' do
        expect(Aldous::LoggingWrapper).to receive(:log).with(e)
        perform
      end

      context 'when error cause is another error' do
        let(:cause) { StandardError.new }
        before do
          allow(e).to receive(:cause) { cause }
        end

        it 'reports the error cause' do
          expect(Aldous::LoggingWrapper).to receive(:log).with(cause)
          perform
        end
      end
    end
  end
end
