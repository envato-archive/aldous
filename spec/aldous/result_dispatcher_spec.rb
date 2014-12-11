RSpec.describe Aldous::ResultDispatcher do
  let(:controller) {double "controller", view_context: nil, request: nil}
  let(:result) {double "result"}
  let(:result_to_response_type_mapping) {Hash.new}

  describe "::execute" do
    before do
      allow(described_class).to receive(:new).and_return(dispatcher)
    end

    let(:dispatcher) {instance_double(described_class, perform: nil)}

    it "instantiates a #{described_class} object" do
      expect(described_class).to receive(:new).with(controller, result, result_to_response_type_mapping)
      described_class.execute(controller, result, result_to_response_type_mapping)
    end

    it "performs the dispatch" do
      expect(dispatcher).to receive(:perform)
      described_class.execute(controller, result, result_to_response_type_mapping)
    end
  end

  describe "#perform" do
    let(:dispatcher) { described_class.new(controller, result, result_to_response_type_mapping) }

    let(:determine_response_type) {instance_double(Aldous::Dispatch::DetermineResponseType, execute: response_type_class)}
    let(:determine_response_status) {instance_double(Aldous::Dispatch::DetermineResponseStatus, execute: response_status)}

    let(:handle_error) {instance_double(Aldous::Dispatch::HandleError, perform: nil)}

    let(:response_type_class) {double "response type class", new: response_type}
    let(:response_status) {double 'response status'}

    let(:response_type) {double "response type", action: response_action}
    let(:response_action) {double "response action", execute: nil}

    before do
      allow(Aldous::Dispatch::DetermineResponseType).to receive(:new).with(result, result_to_response_type_mapping).and_return(determine_response_type)
      allow(Aldous::Dispatch::DetermineResponseStatus).to receive(:new).with(result).and_return(determine_response_status)
      allow(Aldous::Dispatch::HandleError).to receive(:new).and_return(handle_error)
    end

    context "when response type class is found via the mapping" do
      context "and response type class implements one of the valid interfaces" do
        before do
          response_type.extend(Aldous::Renderable)
        end

        it "gets the action from the response type" do
          expect(response_type).to receive(:action).with(controller)
          dispatcher.perform
        end

        it "executes the action" do
          expect(response_action).to receive(:execute).with(response_status)
          dispatcher.perform
        end
      end

      context "and response type class does not implement one of the valid interfaces" do
        it "an error is raised and handled" do
          expect(Aldous::Dispatch::HandleError).to receive(:new).with(instance_of(RuntimeError), controller)
          dispatcher.perform
        end
      end
    end

    context "when response type class is not found via the mapping" do
      let(:response_type_class) {nil}
      let(:find_default_response_types) {double "find default response types", execute: default_response_types}
      let(:default_response_types) {double "default response types", response_type_for: default_response_type_class}
      let(:default_response_type_class) {double 'default response type class', new: response_type}

      before do
        allow(Aldous::Dispatch::Request::FindDefaultResponseTypes).to receive(:new).and_return(find_default_response_types)
      end

      context "but found via configured defaults" do
        context "and response type class implements one of the valid interfaces" do
          before do
            response_type.extend(Aldous::Renderable)
          end

          it "gets the action from the response type" do
            expect(response_type).to receive(:action).with(controller)
            dispatcher.perform
          end

          it "executes the action" do
            expect(response_action).to receive(:execute).with(response_status)
            dispatcher.perform
          end
        end

        context "and response type class does not implement one of the valid interfaces" do
          it "an error is raised and handled" do
            expect(Aldous::Dispatch::HandleError).to receive(:new).with(instance_of(RuntimeError), controller)
            dispatcher.perform
          end
        end
      end

      context "and not found via configured defaults" do
        let(:default_response_type_class) {nil}

        it "an error is raised and handled" do
          expect(Aldous::Dispatch::HandleError).to receive(:new).with(instance_of(RuntimeError), controller)
          dispatcher.perform
        end
      end
    end
  end
end
