RSpec.describe Aldous::Controller::Action::Wrapper do
  let(:wrapper) { described_class.new controller_action }

  let(:controller_action) { double 'controller action',
                            default_view_data: default_view_data,
                            preconditions: preconditions,
                            default_error_respondable: default_error_respondable,
                            perform: nil,
                            build_view: nil }

  let(:default_view_data) { {default_view_data: true} }
  let(:preconditions) { double 'preconditions' }
  let(:default_error_respondable) {double 'default_error_respondable'}

  before do
    allow(Aldous::LoggingWrapper).to receive(:log)
  end

  describe '#perform' do
    subject(:perform) { wrapper.perform }

    it "calls perform on the controller action" do
      expect(controller_action).to receive(:perform)
      perform
    end

    context 'when controller service throws an exception' do
      let(:e) { StandardError.new 'message' }

      before do
        allow(controller_action).to receive(:perform).and_raise(e)
      end

      it "builds a default error view with errors" do
        expect(controller_action).to receive(:build_view).with(default_error_respondable, errors: [e])
        perform
      end

      it 'reports the error' do
        expect(Aldous::LoggingWrapper).to receive(:log).with(e)
        perform
      end
    end
  end
end

