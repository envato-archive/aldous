RSpec.describe Aldous::Service::Result::Success do
  subject(:result) {described_class.new}

  describe "#failure?" do
    it {expect(result.failure?).to eq false}
  end

  describe "#success?" do
    it {expect(result.success?).to eq true}
  end
end
