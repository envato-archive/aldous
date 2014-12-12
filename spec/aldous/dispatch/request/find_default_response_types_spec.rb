RSpec.describe Aldous::Dispatch::Request::FindDefaultResponseTypes do
  let(:find_default_response_types) {described_class.new(request)}

  let(:request) {double "request"}
  let(:request_wrapper) {double "request wrapper", format: format}
  let(:format) {:html}

  before do
    allow(Aldous::Dispatch::Request::RequestWrapper).to receive(:new).and_return(request_wrapper)
  end

  describe "#execute" do
    context "when request wrapper format is html" do
      it "returns the right response types object" do
        expect(find_default_response_types.execute).to be_kind_of Aldous::Dispatch::Request::DefaultResponseTypes::Html
      end
    end
  end
end
