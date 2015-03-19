RSpec.describe Aldous::Controller::Action::Precondition::Wrapper do
  let(:wrapper) { described_class.new precondition }

  let(:precondition) {double 'precondition',
                      action: controller_action,
                      perform: nil,
                      build_view: nil }

  let(:controller_action) { double 'controller action',
                            default_view_data: default_view_data,
                            default_error_respondable: default_error_respondable,
                            perform: nil,
                            build_view: nil }

  let(:default_view_data) { {default_view_data: true} }
  let(:default_error_respondable) {double 'default_error_respondable'}

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

      it "builds a default error view with errors" do
        expect(precondition).to receive(:build_view).with(default_error_respondable, errors: [e])
        perform
      end

      it 'reports the error' do
        expect(Aldous::LoggingWrapper).to receive(:log).with(e)
        perform
      end
    end
  end
end
