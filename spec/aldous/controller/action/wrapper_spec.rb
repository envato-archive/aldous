RSpec.describe Aldous::Controller::Action::Wrapper do
  let(:wrapper) { described_class.new controller_action }

  let(:controller_action) { double 'controller action',
                            default_view_data: default_view_data,
                            preconditions: preconditions,
                            default_error_handler: default_error_handler,
                            view_builder: view_builder,
                            perform: nil }

  let(:default_view_data) { {default_view_data: true} }
  let(:preconditions) { double 'preconditions' }
  let(:default_error_handler) {double 'default_error_handler'}
  let(:view_builder) {double 'view_builder'}

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

      it 'reports the error' do
        expect(Aldous::LoggingWrapper).to receive(:log).with(e)
        perform
      end

      context "and the default error handler is a respondable" do
        let(:default_error_handler) {Aldous::Respondable::Renderable}

        it "builds a default error view with errors" do
          expect(view_builder).to receive(:build).with(default_error_handler, errors: [e])
          perform
        end
      end

      context "and the default error handler is not a respondable" do
        it "doesn't need to do anything" do
          expect(default_error_handler).to_not receive(:build)
          perform
        end
      end
    end
  end
end

