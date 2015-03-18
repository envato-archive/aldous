RSpec.describe Aldous::Configuration do
  subject(:config) {described_class.new}

  describe "#error_reporter" do
    it "is configured to use the dummy error reporter by default" do
      expect(config.error_reporter).to eq ::Aldous::DummyErrorReporter
    end
  end

  describe "#logger" do
    it "is configured to use the stdout logger by default" do
      expect(config.logger).to eq ::Aldous::StdoutLogger
    end
  end
end
