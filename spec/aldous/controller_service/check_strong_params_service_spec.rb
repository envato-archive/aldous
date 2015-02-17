RSpec.describe Aldous::ControllerService::CheckStrongParamsService do
  let(:service) { described_class.new controller_service }
  let(:controller_service) { double 'controller service', strong_params: nil }
  before do
    allow(Aldous.config.error_reporter).to receive(:report)
  end

  describe '#perform' do
    subject(:perform) { service.perform }

    it 'calls strong_params on controller service' do
      expect(controller_service).to receive(:strong_params)
      perform
    end

    context 'when strong_params are received without incident' do
      it 'returns a success result' do
        expect(perform).to be_success
      end
    end

    context 'when calling strong_params raises an exception' do
      let(:e) { StandardError.new 'message' }
      before do
        allow(controller_service).to receive(:strong_params).and_raise(e)
      end

      it 'reports the error' do
        expect(Aldous.config.error_reporter).to receive(:report).with(e)
        perform
      end

      it 'returns a strong params failure result' do
        expect(perform).to be_a Aldous::Result::StrongParamsFailure
      end

      it 'includes error message in the result' do
        expect(perform.error).to eq e.message
      end
    end
  end
end
