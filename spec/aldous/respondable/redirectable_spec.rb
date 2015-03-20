RSpec.describe Aldous::Respondable::Redirectable do
  class Aldous::Respondable::Redirectable::Dummy < described_class
    def location
      'hello'
    end
  end

  subject(:redirectable) {Aldous::Respondable::Redirectable::Dummy.new(status, view_data, view_context)}

  let(:status) {:foo}
  let(:view_data) {double("view_data")}
  let(:view_context) {double("view context")}

  describe "::action" do
    let(:controller) {double("controller")}

    it "returns a redirect response action object" do
      expect(redirectable.action(controller)).to be_kind_of Aldous::Respondable::Redirectable::RedirectAction
    end

    it 'creates a redirect response action with the relevant parameters' do
      expect(Aldous::Respondable::Redirectable::RedirectAction).to receive(:new).with(redirectable.location, controller, view_data, status)
      redirectable.action(controller)
    end
  end
end
