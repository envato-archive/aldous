RSpec.describe Aldous::ControllerService::PerformWithRescue do
  class BadDummy
    include Aldous::ControllerService::PerformWithRescue
  end

  class GoodDummy
    include Aldous::ControllerService::PerformWithRescue

    def perform
      Aldous::Result::Success.new
    end
  end

  class ErrorDummy
    include Aldous::ControllerService::PerformWithRescue

    def default_result_options
      {hello: nil}
    end

    def perform
      raise 'hello'
    end
  end

  class StrongParamsErrorDummy
    include Aldous::ControllerService::PerformWithRescue

    def strong_params
      raise 'hello'
    end

    def perform
    end
  end

  class DefaultOptionsDummy
    include Aldous::ControllerService::PerformWithRescue

    def default_result_options
      {hello: nil}
    end

    def perform
      Aldous::Result::Success.new
    end
  end

  it "gives the class a preconditions method which returns an empty list" do
    expect(GoodDummy.new.preconditions).to eq []
  end

  it "expects a 'perform' method to be defined" do
    expect{BadDummy.new.perform}.to raise_error
  end

  it "calls 'perform' method defined on class" do
    expect(GoodDummy.new.perform).to be_kind_of Aldous::Result::Success
  end

  it "rescues errors in 'perform' method defined on class" do
    expect(ErrorDummy.new.perform).to be_kind_of Aldous::Result::ServerError
  end

  it "has strong params" do
    expect(GoodDummy.new).to be_kind_of Aldous::ControllerService::HasStrongParams
  end

  it "has preconditions" do
    expect(GoodDummy.new).to be_kind_of Aldous::ControllerService::HasPreconditions
  end

  it "has default result options" do
    expect(GoodDummy.new).to be_kind_of Aldous::ControllerService::DefaultResultOptions
  end

  context "default options on every result" do
    it "has default options on a success result" do
      expect{DefaultOptionsDummy.new.perform.hello}.to_not raise_error
    end

    it "has default options on an error result" do
      expect{ErrorDummy.new.perform.hello}.to_not raise_error
    end
  end

  context "strong param checks" do
    let(:service) {GoodDummy.new}

    it "performs and memoizes the strong params checks" do
      service.perform
      expect(service.instance_variable_get(:"@strong_params")).to_not be_nil
    end

    it "returns a failure result when strong params checks fail" do
      expect(StrongParamsErrorDummy.new.perform).to be_kind_of Aldous::Result::Failure
    end
  end

  context "precondition checks" do
    let(:check_preconditions) {instance_double(Aldous::ControllerService::CheckPreconditions, perform: check_preconditions_result)}
    let(:check_preconditions_result) {double "check precondition result", success?: check_preconditions_result_success}
    let(:check_preconditions_result_success) {true}

    before do
      allow(Aldous::ControllerService::CheckPreconditions).to receive(:new).with([]).and_return(check_preconditions)
    end

    it "performs the checks" do
      expect(Aldous::ControllerService::CheckPreconditions).to receive(:new).with([]).and_return(check_preconditions)
      GoodDummy.new.perform
    end

    context "when the check result is not a success" do
      let(:check_preconditions_result_success) {false}

      it "returns the check result" do
        expect(GoodDummy.new.perform).to eq check_preconditions_result
      end
    end
  end

  context "when errors occur" do
    it "reports to the error reporter" do
      expect(Aldous::DummyErrorReporter).to receive(:report).with(instance_of(RuntimeError))
      ErrorDummy.new.perform
    end

    it "returns a server error result" do
      expect(ErrorDummy.new.perform).to be_kind_of Aldous::Result::ServerError
    end
  end
end
