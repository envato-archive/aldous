RSpec.describe Aldous::Controller::PreconditionsExecutionService do
  let(:preconditions_execution_service) {described_class.new(action_wrapper, controller)}

  let(:controller) {double "controller"}
  let(:action_wrapper) {double 'action wrapper', preconditions: preconditions, controller_action: action}
  let(:action) {double 'action'}

  let(:preconditions) { [] }

  describe "#perform" do
    subject(:perform) {preconditions_execution_service.perform}

    context "when no preconditions defined" do
      it "returns an array of nils" do
        expect(perform).to eq [nil, nil]
      end
    end

    context "when preconditions defined" do
      let(:preconditions) { [precondition_class] }
      let(:precondition_class) {double 'precondition_class', build: precondition}
      let(:precondition) {double "precondition", perform: nil}

      it "builds the precondition with the controller_aciont" do
        expect(precondition_class).to receive(:build).with(action)
        perform
      end

      context "but they don't short-circuit execution" do
        it "returns an array of nils" do
          expect(perform).to eq [nil, nil]
        end
      end

      context "and they short-circuit execution" do
        let(:precondition) {double "precondition", perform: precondition_result}
        let(:precondition_result) {Aldous::Respondable::Renderable.new(nil, nil, nil)}

        it "returns an array of precondition and precondition result" do
          expect(perform).to eq [precondition, precondition_result]
        end
      end
    end
  end
end
