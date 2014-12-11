RSpec.describe Aldous::Headable do
  class Dummy
    include Aldous::Headable
  end

  subject(:headable) {Dummy.new(result, view_context)}

  let(:result) {double("result")}
  let(:view_context) {double("view context")}

  describe "::action" do
    let(:controller) {double("controller")}

    it "returns a head response action object" do
      expect(headable.action(controller)).to be_kind_of Aldous::ResponseAction::Head
    end

    it 'creates a head response action with the relevant parameters' do
      expect(Aldous::ResponseAction::Head).to receive(:new).with(controller)
      headable.action(controller)
    end
  end
end
