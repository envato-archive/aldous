RSpec.describe Aldous::DummyLogger do
  describe "::info" do
    it "responds to the info method correctly" do
      expect(described_class.info('blah')).to eq nil
    end
  end
end
