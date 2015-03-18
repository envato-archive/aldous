RSpec.describe Aldous::Respondable::Renderable::RenderAction do
  subject(:respondable) {described_class.new(template, status, controller, view_data)}

  let(:status) {:foo}
  let(:template) { {hello: 'world'} }
  let(:controller) {double 'controller', render: nil, flash: flash }
  let(:view_data) {"blah"}
  let(:response_status) {'world'}

  let(:flash) { double("flash", now: flash_now) }
  let(:flash_now) { double("flash_now") }
  let(:flash_object) { instance_double Aldous::Respondable::Shared::Flash, set_error: nil }

  describe "#execute" do
    before do
      allow(Aldous::Respondable::Shared::Flash).to receive(:new){ flash_object }
    end

    it "calls render on controller with the relevant options" do
      expect(controller).to receive(:render).with(template.merge(status: status))
      respondable.execute
    end

    it "tries to set flash" do
      expect(Aldous::Respondable::Shared::Flash).to receive(:new).with(view_data, flash_now)
      respondable.execute
    end

    it "calls set_error on flash object" do
      expect(flash_object).to receive(:set_error)
      respondable.execute
    end
  end
end
