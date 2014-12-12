RSpec.describe Aldous::Dispatch::HandleError do
  let(:handle_error) {described_class.new(error, controller)}

  let(:controller) {double "controller", request: nil, view_context: view_context, head: nil}
  let(:view_context) {double "view context"}
  let(:error) {double "error"}

  describe "#perform" do
    let(:find_default_response_types) {double "find default response types", execute: default_response_types}
    let(:default_response_types) {double "default response types", response_type_for: response_type_class}
    let(:response_type_class) {double "response type class", new: response_type}
    let(:response_type) {double "response type", action: response_type_action}
    let(:response_type_action) {double "response type action", execute: nil}
    let(:server_error) {double "server error"}

    let(:determine_response_status) {double "determine response status", execute: response_status}
    let(:response_status) {'hello'}

    before do
      allow(Aldous::Dispatch::Request::FindDefaultResponseTypes).to receive(:new).and_return(find_default_response_types)
      allow(Aldous::Dispatch::DetermineResponseStatus).to receive(:new).and_return(determine_response_status)
      allow(Aldous::Result::ServerError).to receive(:new).and_return(server_error)
    end

    context "when nothing goes wrong" do
      it "builds a server error as a result" do
        expect(Aldous::Result::ServerError).to receive(:new).and_return(server_error)
        handle_error.perform
      end

      it "reports the error" do
        expect(Aldous::DummyErrorReporter).to receive(:report).with(error)
        handle_error.perform
      end

      it "builds a response type" do
        expect(response_type_class).to receive(:new).with(server_error, view_context)
        handle_error.perform
      end

      it "gets the action from the response type" do
        expect(response_type).to receive(:action).with(controller)
        handle_error.perform
      end

      it "executes the response type action" do
        expect(response_type_action).to receive(:execute).with(response_status)
        handle_error.perform
      end
    end

    context "when an error occurs" do
      before do
        allow(Aldous::Result::ServerError).to receive(:new).and_raise(RuntimeError.new)
      end

      it "calls head on controller with internal server error" do
        allow(controller).to receive(:head).with(:internal_server_error)
        handle_error.perform
      end
    end
  end
end
