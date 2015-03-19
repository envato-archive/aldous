RSpec.describe Aldous::Controller::ActionExecutionService do
  let(:action_execution_service) {described_class.new(controller, controller_action_class)}

  let(:controller) {double "controller", head: nil}
  let(:controller_action_class) {double "controller_action_class", build: action}

  let(:action) {double 'action', perform: action_result, default_view_data: default_view_data}
  let(:action_result) {'foobar'}
  let(:default_view_data) {'hello'}

  describe "::perform" do
    subject(:perform) {described_class.perform(controller, controller_action_class)}

    let(:action_execution_service) {double "action_execution_service", perform: nil}

    before do
      allow(described_class).to receive(:new).and_return(action_execution_service)
    end

    it "instantiates the action execution service" do
      expect(described_class).to receive(:new).with(controller, controller_action_class)
      perform
    end

    it "performs the action execution service" do
      expect(action_execution_service).to receive(:perform)
      perform
    end
  end

  describe "#perform" do
    subject(:perform) {action_execution_service.perform}

    let(:preconditions_execution_service) {double "preconditions_execution_service", perform: preconditions_result}
    let(:preconditions_result) {[nil, nil]}

    before do
      allow(Aldous::Controller::PreconditionsExecutionService).to receive(:new).and_return(preconditions_execution_service)
      allow(Aldous::Controller::Action::ResultExecutionService).to receive(:perform)
    end

    context "when preconditions did not halt execution" do
      it "executes the result with action_result" do
        expect(Aldous::Controller::Action::ResultExecutionService).to receive(:perform).with(controller, action_result, default_view_data)
        perform
      end
    end

    context "when preconditions did halt execution" do
      let(:preconditions_result) {[precondition, precondition_result]}

      let(:precondition) {double 'precondition', perform: precondition_result, default_view_data: default_view_data}
      let(:precondition_result) {'preconditionfoobar'}
      let(:default_view_data) {'precondtionhello'}

      it "executes the result with precondition_result" do
        expect(Aldous::Controller::Action::ResultExecutionService).to receive(:perform).with(controller, precondition_result, default_view_data)
        perform
      end
    end

    context "when error occurs" do
      before do
        allow(Aldous::LoggingWrapper).to receive(:log)
        allow(Aldous::Controller::PreconditionsExecutionService).to receive(:new).and_raise
      end

      it "logs the error" do
        expect(Aldous::LoggingWrapper).to receive(:log)
        perform
      end

      it "returns a 500 via controller" do
        expect(controller).to receive(:head).with(:internal_server_error)
        perform
      end
    end
  end
end
