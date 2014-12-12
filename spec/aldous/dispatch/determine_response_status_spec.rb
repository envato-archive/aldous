RSpec.describe Aldous::Dispatch::DetermineResponseStatus do
  let(:determine_response_status) {described_class.new(result)}

  let(:result) {Aldous::Result::Success.new(cause: result_cause)}
  let(:result_cause) {Aldous::Result::Failure.new}

  describe "#execute" do
    context "when the result has a cause which is also a type of result" do
      it "returns the status for the cause result" do
        expect(determine_response_status.execute).to eq :unprocessable_entity
      end
    end

    context "when the result has no cause" do
      let(:result_cause) {nil}

      it "returns the status for the result" do
        expect(determine_response_status.execute).to eq :ok
      end
    end

    context "when the result has a cause which is not a result" do
      let(:result_cause) {'hello'}

      it "returns the status for the result" do
        expect(determine_response_status.execute).to eq :ok
      end
    end

    context "when no status can be found for result" do
      let(:result) {'hello'}

      it "returns error status" do
        expect(determine_response_status.execute).to eq :internal_server_error
      end
    end
  end
end
