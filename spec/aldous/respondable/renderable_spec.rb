RSpec.describe Aldous::Respondable::Renderable do
  class Aldous::Respondable::Renderable::Dummy < described_class
    def template
      'hello'
    end
  end

  class Aldous::Respondable::Renderable::Dummy2 < described_class
    def template
      {}
    end
  end

  subject(:renderable) {Aldous::Respondable::Renderable::Dummy.new(result, view_context)}

  let(:result) {double("result")}
  let(:view_context) {double("view context")}

  describe "#action" do
    let(:controller) {double("controller")}

    it "returns a render response action object" do
      expect(renderable.action(controller)).to be_kind_of Aldous::Respondable::Renderable::RenderAction
    end

    it 'creates a redirect response action with the relevant parameters' do
      expect(Aldous::Respondable::Renderable::RenderAction).to receive(:new).with(renderable.template, controller, result)
      renderable.action(controller)
    end
  end

  describe "#template" do
    subject(:renderable) {Aldous::Respondable::Renderable.new(result, view_context)}

    it "raises an error since template method wasn't overridden" do
      expect {renderable.template}.to raise_error(::Aldous::Errors::UserError)
    end
  end

  describe "#template_with_locals" do
    it "raises an error since template method doesn't return a hash" do
      expect {renderable.template_with_locals}.to raise_error(::Aldous::Errors::UserError)
    end

    context "when template method returns a hash" do
      subject(:renderable) {Aldous::Respondable::Renderable::Dummy2.new(result, view_context)}

      let(:extra_locals) { {hello: 'world'} }
      let(:template_with_extra_locals) { {locals: extra_locals} }

      it "adds all the extra locals to template locals" do
        expect(renderable.template_with_locals(extra_locals)).to eq template_with_extra_locals
      end
    end
  end
end
