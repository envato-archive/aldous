RSpec.describe Aldous::Service::CheckPreconditions do
  class BadPrecondition
  end

  class SuccessPrecondition
    include Aldous::Service::Precondition

    def check
      Aldous::Result::Success.new
    end
  end

  class FailurePrecondition
    include Aldous::Service::Precondition

    def check
      Aldous::Result::Failure.new(hello: 'world')
    end
  end

  let(:check_preconditions) {described_class.new(preconditions)}
  let(:preconditions) {[]}

  context "when precondition does not implement the preconditions module" do
    let(:preconditions) {[BadPrecondition.new]}

    it "raises an error" do
      expect{check_preconditions.perform}.to raise_error
    end
  end

  context "when several preconditions given" do
    let(:preconditions) {[precondition1, precondition2]}
    let(:precondition1) {SuccessPrecondition.new}
    let(:precondition2) {SuccessPrecondition.new}

    it "checks every precondition" do
      expect(precondition1).to receive(:check).and_call_original
      expect(precondition2).to receive(:check).and_call_original
      check_preconditions.perform
    end

    it "returns success result when all preconditions pass" do
      expect(check_preconditions.perform).to be_kind_of Aldous::Result::Success
    end

    context "and some preconditions fail" do
      let(:precondition2) {FailurePrecondition.new}

      it "returns the relevant precondition failure result" do
        expect(check_preconditions.perform).to be_kind_of Aldous::Result::FailurePreconditionFailure
      end

      it "returns the precondition failure with the original failure result as cause" do
        expect(check_preconditions.perform.cause).to be_kind_of Aldous::Result::Failure
      end

      it "returns the precondition failure with all the options from the original failure" do
        expect(check_preconditions.perform.hello).to eq 'world'
      end
    end
  end
end
