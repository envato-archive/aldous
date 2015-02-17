RSpec.describe Aldous::ControllerService::Wrapper do
  let(:wrapper) { described_class.new controller_service }
  let(:controller_service) { double 'controller service', default_result_options: default_result_options, preconditions: preconditions, perform: controller_service_result }
  let(:default_result_options) { {default_result_option: true} }
  let(:preconditions) { double 'preconditions' }
  let(:controller_service_result) { Aldous::Result::Success.new service_result_option: true }
  before do
    allow(Aldous.config.error_reporter).to receive(:report)
  end

  describe '#perform' do
    subject(:perform) { wrapper.perform }
    let(:check_strong_params_result) { Aldous::Result::Success.new }
    let(:check_preconditions_result) { Aldous::Result::Success.new }
    before do
      allow(Aldous::ControllerService::CheckStrongParamsService).to receive(:perform) { check_strong_params_result }
      allow(Aldous::ControllerService::CheckPreconditionsService).to receive(:perform) { check_preconditions_result }
    end

    it 'checks strong parameters for controller service' do
      expect(Aldous::ControllerService::CheckStrongParamsService).to receive(:perform).with(controller_service)
      perform
    end

    context 'when strong params check fails' do
      let(:check_strong_params_result) { Aldous::Result::Failure.new }

      it 'returns result of strong params check' do
        expect(perform).to be check_strong_params_result
      end
    end

    it 'checks controller service preconditions' do
      expect(Aldous::ControllerService::CheckPreconditionsService).to receive(:perform).with(preconditions)
      perform
    end

    context 'when preconditions check fails' do
      let(:check_preconditions_result) { Aldous::Result::Failure.new }

      it 'returns result of preconditions check' do
        expect(perform).to be check_preconditions_result
      end
    end

    context 'when checks are successful' do
      it 'calls perform on the controller service' do
        expect(controller_service).to receive(:perform)
        perform
      end

      it 'returns a result with same type as the controller service result' do
        expect(perform.class).to be controller_service_result.class
      end

      it 'includes default result options in result' do
        expect(perform.default_result_option).to eq true
      end

      it 'includes service result options in result' do
        expect(perform.service_result_option).to eq true
      end
    end

    context 'when controller service throws an exception' do
      let(:e) { StandardError.new 'message' }
      before do
        allow(controller_service).to receive(:perform).and_raise(e)
      end

      it 'returns a ServerError result' do
        expect(perform).to be_a Aldous::Result::ServerError
      end

      it 'includes default result options in result' do
        expect(perform.default_result_option).to eq true
      end

      it 'includes errors in result' do
        expect(perform.errors).to eq [e]
      end

      it 'reports the error' do
        expect(Aldous::config.error_reporter).to receive(:report).with(e)
        perform
      end
    end
  end
end
