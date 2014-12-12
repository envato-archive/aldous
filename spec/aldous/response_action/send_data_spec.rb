RSpec.describe Aldous::ResponseAction::SendData do
  subject(:respondable) {described_class.new(data, options, controller, result)}

  let(:data) { 'hello' }
  let(:options) {'world'}
  let(:controller) {double 'controller', render: nil}
  let(:result) {"blah"}

  describe "#execute" do
    it "calls render on controller with the relevant options" do
      expect(controller).to receive(:send_data).with(data, options)
      respondable.execute
    end
  end
end
