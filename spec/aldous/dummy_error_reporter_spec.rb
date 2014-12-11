RSpec.describe Aldous::DummyErrorReporter do
  describe "::report" do
    let(:error) {RuntimeError.new('blah')}
    let(:data) { Hash.new }

    it "responds to the report method correctly" do
      expect(described_class.report(error, data)).to eq nil
    end
  end
end
