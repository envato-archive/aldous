RSpec.describe Aldous::Dispatch::Request::RequestWrapper do
  let(:request_wrapper) {described_class.new(request)}
  let(:request) {double "request", format: format}
  let(:format) {'json'}

  describe "#format" do
    context "when format is specified" do
      it "returns the format as a symbol" do
        expect(request_wrapper.format).to eq :json
      end
    end

    context "when format is not specified" do
      let(:format) {nil}

      it "returns html as a symbol" do
        expect(request_wrapper.format).to eq :html
      end
    end
  end
end
