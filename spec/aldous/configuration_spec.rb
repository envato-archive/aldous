RSpec.describe Aldous::Configuration do
  subject(:config) {described_class.new}

  describe "#error_reporter" do
    it "is configured to use the dummy error reporter by default" do
      expect(config.error_reporter).to eq ::Aldous::DummyErrorReporter
    end
  end

  describe "#default_json_response_types" do
    it "has no default json response types configured" do
      expect(config.default_json_response_types).to eq Hash.new
    end
  end

  describe "#default_html_response_types" do
    it "has no default html response types configured" do
      expect(config.default_html_response_types).to eq Hash.new
    end
  end

  describe "#default_atom_response_types" do
    it "has no default atom response types configured" do
      expect(config.default_atom_response_types).to eq Hash.new
    end
  end
end
