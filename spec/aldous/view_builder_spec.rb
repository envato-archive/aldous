RSpec.describe Aldous::ViewBuilder do
  let(:view_builder) { described_class.new(view_context, default_view_data) }

  let(:view_context)      { double "view_context" }
  let(:default_view_data) { {hello: 1} }
  let(:respondable_class) { double "respondable_class"}
  let(:extra_data)        { {world: 2} }
  let(:status)            { :foo }

  let(:simple_dto) {instance_double(Aldous::SimpleDto)}
  let(:respondable_instance) {double "respondable_instance"}

  describe "#build" do
    subject(:build) {view_builder.build(respondable_class, extra_data)}

    let(:view_data) { {hello: 1, world: 2} }

    before do
      allow(Aldous::SimpleDto).to receive(:new).and_return(simple_dto)
      allow(respondable_class).to receive(:new).and_return(respondable_instance)
    end

    context "when status is part of the extra_data" do
      let(:extra_data) { {world: 2, status: status} }

      it "creates a dto with the correct data" do
        expect(Aldous::SimpleDto).to receive(:new).with(view_data).and_return(simple_dto)
        build
      end
    end

    it "creates a dto with the correct data" do
      expect(Aldous::SimpleDto).to receive(:new).with(view_data).and_return(simple_dto)
      build
    end

    it "returns a respondable instance" do
      expect(respondable_class).to receive(:new).with(nil, simple_dto, view_context)
      build
    end
  end
end
