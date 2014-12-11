RSpec.describe Aldous::Renderable do
  class Dummy
    include Aldous::Renderable

    def template
      'hello'
    end
  end

  subject(:renderable) {Dummy.new(result, view_context)}

  let(:result) {double("result")}
  let(:view_context) {double("view context")}

  describe "::action" do
    let(:controller) {double("controller")}

    it "returns a render response action object" do
      expect(renderable.action(controller)).to be_kind_of Aldous::ResponseAction::Render
    end

    it 'creates a redirect response action with the relevant parameters' do
      expect(Aldous::ResponseAction::Render).to receive(:new).with(renderable.template, controller, result)
      renderable.action(controller)
    end
  end
end
