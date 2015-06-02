RSpec.describe Aldous::Controller::Action::ResultExecutionService do
  let(:result_execution_service) {described_class.new(controller, respondable, default_view_data)}

  let(:controller) {double "controller", view_context: view_context}

  let(:view_context) {double "view_context"}

  let(:respondable) do
    double "respondable", {
      class: respondable_class,
      status: respondable_status,
      view_data: respondable_view_data,
    }
  end

  let(:respondable_class) {double "respondable_class", new: complete_respondable}
  let(:respondable_status) {double "respondable_status"}
  let(:respondable_view_data) {double "respondable_view_data", _data: view_data_hash}
  let(:view_data_hash) { {foo: 'bar'} }

  let(:default_view_data) { {hello: 'world'} }

  let(:complete_respondable) do
    double "complete_respondable", {
      action: action
    }
  end

  let(:action) {double 'action', execute: nil}

  describe "::perform" do
    subject(:perform) {described_class.perform(controller, respondable, default_view_data)}

    let(:result_execution_service) {double "result_execution_service", perform: nil}

    before do
      allow(described_class).to receive(:new).and_return(result_execution_service)
    end

    it "instantiates the result execution service" do
      expect(described_class).to receive(:new).with(controller, respondable, default_view_data)
      perform
    end

    it "performs the result execution service" do
      expect(result_execution_service).to receive(:perform)
      perform
    end
  end

  describe "#perform" do
    subject(:perform) {result_execution_service.perform}

    it "fetches the action from the complete respondable" do
      expect(complete_respondable).to receive(:action).with(controller)
      perform
    end

    it "executes the complete respondable action" do
      expect(action).to receive(:execute)
      perform
    end
  end
end


        #def perform
          #complete_respondable.action(controller).execute
        #end

        #private

        #def complete_respondable
          #@complete_respondable ||= update_respondable_with_default_view_data
        #end

        #def update_respondable_with_default_view_data
          #status            = respondable.status
          #extra_data        = respondable.view_data._data
          #actual_extra_data = default_view_data.merge(extra_data)
          #view_data         = SimpleDto.new(actual_extra_data)

          #respondable.class.new(status, view_data, controller.view_context)
        #end

