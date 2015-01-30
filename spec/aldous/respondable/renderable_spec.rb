RSpec.describe Aldous::Respondable::Renderable do
  class Aldous::Respondable::Renderable::Dummy < described_class
    def template
      'hello'
    end
  end

  subject(:renderable) {Aldous::Respondable::Renderable::Dummy.new(result, view_context)}

  let(:result) {double("result")}
  let(:view_context) {double("view context")}

  describe "::action" do
    let(:controller) {double("controller")}

    it "returns a render response action object" do
      expect(renderable.action(controller)).to be_kind_of Aldous::Respondable::Renderable::RenderAction
    end

    it 'creates a redirect response action with the relevant parameters' do
      expect(Aldous::Respondable::Renderable::RenderAction).to receive(:new).with(renderable.template, controller, result)
      renderable.action(controller)
    end
  end
end
