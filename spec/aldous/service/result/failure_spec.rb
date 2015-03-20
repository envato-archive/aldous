RSpec.describe Aldous::Service::Result::Failure do
  subject(:result) {described_class.new}

  describe "#failure?" do
    it {expect(result.failure?).to eq true}
  end

  describe "#success?" do
    it {expect(result.success?).to eq false}
  end
end
