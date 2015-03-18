RSpec.describe Aldous::Respondable::Headable::HeadAction do
  subject(:respondable) {described_class.new(controller, status)}

  let(:controller) {double 'controller'}
  let(:status) {'hello'}

  before do
    allow(controller).to receive(:head).with(status)
  end

  describe "#execute" do
    it "calls head on controller with status" do
      expect(controller).to receive(:head).with(status)
      respondable.execute
    end
  end
end
