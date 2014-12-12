RSpec.describe Aldous::Dispatch::Request::DefaultResponseTypes::Atom do
  let(:response_types) {described_class.new}

  describe "#default_view" do
    it "returns the blank atom view" do
      expect(response_types.default_view).to eq Aldous::View::Blank::AtomView
    end
  end

  describe "#configured_default_response_types" do
    it "returns the default atom response types from config" do
      expect(Aldous.config).to receive(:default_atom_response_types)
      response_types.configured_default_response_types
    end
  end
end
