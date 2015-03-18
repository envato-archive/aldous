RSpec.describe Aldous::BuildRespondableService do
  let(:service) do
    described_class.new(
      view_context: view_context,
      default_view_data: default_view_data,
      respondable_class: respondable_class,
      status: status,
      extra_data: extra_data
    )
  end

  let(:view_context)      { double "view_context" }
  let(:default_view_data) { {hello: 1} }
  let(:respondable_class) { double "respondable_class"}
  let(:status)            { :foo }
  let(:extra_data)        { {world: 2} }

  let(:simple_dto) {instance_double(Aldous::SimpleDto)}
  let(:respondable_instance) {double "respondable_instance"}

  describe "#perform" do
    let(:view_data) { {hello: 1, world: 2} }

    before do
      allow(Aldous::SimpleDto).to receive(:new).and_return(simple_dto)
      allow(respondable_class).to receive(:new).and_return(respondable_instance)
    end

    context "when status is part of the extra_data" do
      let(:extra_data) { {world: 2, status: status} }

      it "creates a dto with the correct data" do
        expect(Aldous::SimpleDto).to receive(:new).with(view_data).and_return(simple_dto)
        service.perform
      end
    end

    it "creates a dto with the correct data" do
      expect(Aldous::SimpleDto).to receive(:new).with(view_data).and_return(simple_dto)
      service.perform
    end

    it "returns a respondable instance" do
      expect(respondable_class).to receive(:new).with(status, simple_dto, view_context)
      service.perform
    end
  end
end
