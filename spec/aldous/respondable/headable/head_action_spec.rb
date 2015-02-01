RSpec.describe Aldous::Respondable::Headable::HeadAction do
  subject(:respondable) {described_class.new(controller)}

  let(:controller) {double 'controller', head: nil}
  let(:response_status) {'hello'}

  describe "#execute" do
    it "calls head on controller with status" do
      expect(controller).to receive(:head).with(response_status)
      respondable.execute(response_status)
    end
  end
end
