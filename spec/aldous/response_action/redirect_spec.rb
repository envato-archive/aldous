RSpec.describe Aldous::ResponseAction::Redirect do
  subject(:respondable) {described_class.new(location, controller, result, provided_response_status)}

  let(:location) {"hello"}
  let(:controller) {double 'controller', redirect_to: nil}
  let(:result) {"blah"}
  let(:response_status) {'world'}
  let(:provided_response_status) { :found }

  let(:flash) {double("flash", set_error: nil)}

  describe "#execute" do
    before do
      allow(Aldous::ResponseAction::Flash).to receive(:for_redirect).with(controller, result).and_return(flash)
    end

    it "calls redirect_to on controller with the relevant options" do
      expect(controller).to receive(:redirect_to).with(location, {status: provided_response_status})
      respondable.execute(response_status)
    end

    it "tries to set flash" do
      expect(Aldous::ResponseAction::Flash).to receive(:for_redirect).with(controller, result)
      respondable.execute(response_status)
    end
  end
end
