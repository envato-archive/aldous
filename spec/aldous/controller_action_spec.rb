RSpec.describe Aldous::ControllerAction do
  before do
    class ExampleControllerAction < Aldous::ControllerAction
    end
  end

  after do
    Object.send :remove_const, 'ExampleControllerAction'
  end

  let(:action) {ExampleControllerAction.new(controller)}

  let(:controller) {double 'controller', view_context: view_context}
  let(:view_context) {double "view_context"}

  describe "::build" do
    before do
      allow(ExampleControllerAction).to receive(:new).and_return(action)
      allow(Aldous::Controller::Action::Wrapper).to receive(:new)
    end

    it "wraps a controller action instance" do
      expect(Aldous::Controller::Action::Wrapper).to receive(:new).with(action)
      ExampleControllerAction.build(controller)
    end
  end

  describe "::perform" do
    let(:wrapper) {double "wrapper", perform: nil}

    before do
      allow(ExampleControllerAction).to receive(:new).and_return(action)
      allow(Aldous::Controller::Action::Wrapper).to receive(:new).and_return(wrapper)
    end

    it "calls perform on the wrapper" do
      expect(wrapper).to receive(:perform)
      ExampleControllerAction.perform(controller)
    end
  end

  describe "::inherited" do
    context "a controller action instance" do
      Aldous.configuration.controller_methods_exposed_to_action.each do |method_name|
        it "responds to #{method_name}" do
          expect(action).to respond_to method_name
        end
      end
    end
  end

  describe "#perform" do
    it "raises an error since it should be overridden" do
      expect{action.perform}.to raise_error
    end
  end

  describe "#default_view_data" do
    it "is a blank hash by default" do
      expect(action.default_view_data).to eq Hash.new
    end
  end

  describe "#preconditions" do
    it "is a blank array by default" do
      expect(action.preconditions).to eq []
    end
  end

  describe "#default_error_respondable" do
    it "is a blank html view by default" do
      expect(action.default_error_respondable).to eq Aldous::View::Blank::HtmlView
    end
  end

  describe "#build_view" do
    before do
      allow(Aldous::BuildRespondableService).to receive(:new).with(
        view_context: view_context,
        default_view_data: Hash.new,
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
      action.build_view(respondable_class, extra_data)
    end
  end
end
