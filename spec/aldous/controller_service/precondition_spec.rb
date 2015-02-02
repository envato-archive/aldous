RSpec.describe Aldous::ControllerService::Precondition do
  class Dummy
    include Aldous::ControllerService::Precondition
  end

  it "creates a Failure result class named after the class where the module was included" do
    expect{Dummy::Failure.new}.to_not raise_error
  end

  it "the failure result is a type of failure" do
    expect(Dummy::Failure.new.failure?).to eq true
  end

  it "the failure result is a type of precondition failure" do
    expect(Dummy::Failure.new.precondition_failure?).to eq true
  end
end
