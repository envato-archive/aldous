RSpec.describe Aldous::Result::PreconditionFailure do
  subject(:result) {described_class.new}

  describe "#failure?" do
    it {expect(result.failure?).to eq true}
  end

  describe "#not_found?" do
    it {expect(result.not_found?).to eq false}
  end

  describe "#precondition_failure?" do
    it {expect(result.precondition_failure?).to eq true}
  end

  describe "#server_error?" do
    it {expect(result.server_error?).to eq false}
  end

  describe "#success?" do
    it {expect(result.success?).to eq false}
  end

  describe "#unauthenticated?" do
    it {expect(result.unauthenticated?).to eq false}
  end

  describe "#unauthorized?" do
    it {expect(result.unauthorized?).to eq false}
  end
end
