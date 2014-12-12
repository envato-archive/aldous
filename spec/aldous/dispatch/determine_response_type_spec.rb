RSpec.describe Aldous::Dispatch::DetermineResponseType do
  let(:determine_response_type) {described_class.new(result, result_to_response_type_mapping)}

  let(:result) {double"result", class: 'foobar'}
  let(:result_to_response_type_mapping) { {'foobar' => 'hello'} }

  describe "#execute" do
    it "gets the response type from the mapping" do
      expect(determine_response_type.execute).to eq "hello"
    end
  end
end
