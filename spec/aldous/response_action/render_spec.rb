RSpec.describe Aldous::ResponseAction::Render do
  subject(:respondable) {described_class.new(template, controller, result)}

  let(:template) { {hello: 'world'} }
  let(:controller) {double 'controller', render: nil}
  let(:result) {"blah"}
  let(:response_status) {'world'}

  let(:flash) {double("flash", set_error: nil)}

  describe "#execute" do
    before do
      allow(Aldous::ResponseAction::Flash).to receive(:for_render).with(controller, result).and_return(flash)
    end

    it "calls render on controller with the relevant options" do
      expect(controller).to receive(:render).with(template.merge(status: response_status))
      respondable.execute(response_status)
    end

    it "tries to set flash" do
      expect(Aldous::ResponseAction::Flash).to receive(:for_render).with(controller, result)
      respondable.execute(response_status)
    end
  end
end
