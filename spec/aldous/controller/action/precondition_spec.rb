RSpec.describe Aldous::Controller::Action::Precondition do
  before do
    class ExamplePrecondition < Aldous::Controller::Action::Precondition
    end
  end

  after do
    Object.send :remove_const, 'ExamplePrecondition'
  end

  let(:precondition) {ExamplePrecondition.new(action)}

  let(:action) {double 'action', controller: controller, default_view_data: default_view_data}
  let(:controller) {double 'controller', view_context: view_context}
  let(:view_context) {double "view_context"}
  let(:default_view_data) {double "default_view_data"}

  describe "::build" do
    before do
      allow(ExamplePrecondition).to receive(:new).and_return(precondition)
      allow(Aldous::Controller::Action::Precondition::Wrapper).to receive(:new)
    end

    it "wraps a controller action instance" do
      expect(Aldous::Controller::Action::Precondition::Wrapper).to receive(:new).with(precondition)
      ExamplePrecondition.build(action)
    end
  end

  describe "::perform" do
    let(:wrapper) {double "wrapper", perform: nil}

    before do
      allow(ExamplePrecondition).to receive(:new).and_return(action)
      allow(Aldous::Controller::Action::Precondition::Wrapper).to receive(:new).and_return(wrapper)
    end

    it "calls perform on the wrapper" do
      expect(wrapper).to receive(:perform)
      ExamplePrecondition.perform(action)
    end
  end

  describe "::inherited" do
    context "a precondition instance" do
      Aldous.configuration.controller_methods_exposed_to_action.each do |method_name|
        it "responds to #{method_name}" do
          expect(precondition).to respond_to method_name
        end
      end
    end
  end

  describe "#perform" do
    it "raises an error since it should be overridden" do
      expect{precondition.perform}.to raise_error
    end
  end

  describe "#build_view" do
    before do
      allow(Aldous::BuildRespondableService).to receive(:new).with(
        view_context: view_context,
        default_view_data: default_view_data,
        respondable_class: respondable_class,
        status: nil,
        extra_data: extra_data
      ).and_return(build_respondable_service)
    end

    let(:respondable_class) {double "respondable_class"}
    let(:extra_data) { {hello: 1} }

    let(:build_respondable_service) {double "build_respondable_service", perform: nil}

    it "executes the BuildRespondableService" do
      expect(build_respondable_service).to receive(:perform)
      precondition.build_view(respondable_class, extra_data)
    end
  end
end
