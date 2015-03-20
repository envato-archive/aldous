RSpec.describe Aldous::Respondable::Renderable do
  class Aldous::Respondable::Renderable::Dummy < described_class
    def template_data
      {
        locals: {hello: 1}
      }
    end

    def default_template_locals
      {
        hello: 2
      }
    end
  end

  subject(:renderable) {Aldous::Respondable::Renderable::Dummy.new(status, view_data, view_context)}

  let(:status) {:foo}
  let(:view_data) {double("view_data")}
  let(:view_context) {double("view context")}

  describe "#action" do
    let(:controller) {double("controller")}

    it "returns a render response action object" do
      expect(renderable.action(controller)).to be_kind_of Aldous::Respondable::Renderable::RenderAction
    end

    it 'creates a redirect response action with the relevant parameters' do
      expect(Aldous::Respondable::Renderable::RenderAction).to receive(:new).with(renderable.template, status, controller, view_data)
      renderable.action(controller)
    end
  end

  describe "#template" do
    subject(:renderable) {Aldous::Respondable::Renderable::Dummy.new(status, view_data, view_context)}

    it "overrides the default locals with the template locals" do
      expect(renderable.template).to eq({locals: {hello: 1}})
    end

    it "overrides the template locals with the provided locals" do
      expect(renderable.template(hello: 3)).to eq({locals: {hello: 3}})
    end
  end
end
