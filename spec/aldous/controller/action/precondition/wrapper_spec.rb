RSpec.describe Aldous::Controller::Action::Precondition::Wrapper do
  let(:wrapper) { described_class.new precondition }

  let(:precondition) {double 'precondition',
                      action: controller_action,
                      perform: nil }

  let(:controller_action) { double 'controller action',
                            default_view_data: default_view_data,
                            default_error_handler: default_error_handler,
                            perform: nil }

  let(:default_view_data) { {default_view_data: true} }
  let(:default_error_handler) {double 'default_error_handler'}

  before do
    allow(Aldous::LoggingWrapper).to receive(:log)
  end

  describe '#perform' do
    subject(:perform) { wrapper.perform }

    it "calls perform on the precondition" do
      expect(precondition).to receive(:perform)
      perform
    end

    context 'when precondition throws an exception' do
      let(:e) { StandardError.new 'message' }

      before do
        allow(precondition).to receive(:perform).and_raise(e)
      end

      context "when the default error handler is not a respondable" do
        it "calls the default error handler" do
          allow(controller_action).to receive(:default_error_handler).with(e)
          perform
        end
      end

      context "when the default error handler is a respondable" do
        let(:default_error_handler) {Aldous::Respondable::Renderable}

        it "builds the default error handler" do
          allow(default_error_handler).to receive(:build).with(errors: [e])
          perform
        end
      end

      it 'reports the error' do
        expect(Aldous::LoggingWrapper).to receive(:log).with(e)
        perform
      end
    end
  end
end
