RSpec.describe Aldous::Dispatch::Request::DefaultResponseTypes::Html do
  let(:response_types) {described_class.new}

  describe "#default_view" do
    it "returns the blank html view" do
      expect(response_types.default_view).to eq Aldous::View::Blank::HtmlView
    end
  end

  describe "#configured_default_response_types" do
    it "returns the default html response types from config" do
      expect(Aldous.config).to receive(:default_html_response_types)
      response_types.configured_default_response_types
    end
  end
end
