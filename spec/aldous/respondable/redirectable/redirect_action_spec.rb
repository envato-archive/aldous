RSpec.describe Aldous::Respondable::Redirectable::RedirectAction do
  subject(:respondable) {described_class.new(location, controller, view_data, status)}

  let(:location) {"hello"}
  let(:controller) {double 'controller', redirect_to: nil, flash: flash }
  let(:view_data) {"blah"}
  let(:response_status) {'world'}
  let(:status) { :found }

  let(:flash) { double("flash") }
  let(:flash_object) { instance_double Aldous::Respondable::Shared::Flash, set_error: nil }


  describe "#execute" do
    before do
      allow(Aldous::Respondable::Shared::Flash).to receive(:new){ flash_object }
    end

    it "calls redirect_to on controller with the relevant options" do
      expect(controller).to receive(:redirect_to).with(location, {status: status})
      respondable.execute
    end

    it "tries to set flash" do
      expect(Aldous::Respondable::Shared::Flash).to receive(:new).with(view_data, flash)
      respondable.execute
    end

    it "calls set_error on flash object" do
      expect(flash_object).to receive(:set_error)
      respondable.execute
    end
  end
end
