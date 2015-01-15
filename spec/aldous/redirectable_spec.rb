RSpec.describe Aldous::Redirectable do
  class Aldous::Redirectable::Dummy
    include Aldous::Redirectable

    def location
      'hello'
    end
  end

  subject(:redirectable) {Aldous::Redirectable::Dummy.new(result, view_context)}

  let(:result) {double("result")}
  let(:view_context) {double("view context")}

  describe "::action" do
    let(:controller) {double("controller")}

    it "returns a redirect response action object" do
      expect(redirectable.action(controller)).to be_kind_of Aldous::ResponseAction::Redirect
    end

    it 'creates a redirect response action with the relevant parameters' do
      expect(Aldous::ResponseAction::Redirect).to receive(:new).with(redirectable.location, controller, result, :found)
      redirectable.action(controller)
    end
  end
end
