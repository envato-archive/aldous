RSpec.describe Aldous::Params do
  describe "::build" do
    it "instantiates a new params object" do
      expect(described_class).to receive(:new)
      described_class.build({})
    end
  end

  describe "#fetch" do
    let(:params_object) {described_class.new(params)}
    let(:params) { {} }

    context "when error occurs" do
      before do
        allow(params_object).to receive(:permitted_params).and_raise(RuntimeError.new)
        allow(Aldous::LoggingWrapper).to receive(:log)
      end

      it "logs the error" do
        expect(Aldous::LoggingWrapper).to receive(:log)
        params_object.fetch
      end

      it "returns nil" do
        expect(params_object.fetch).to be_nil
      end
    end

    context "when no error occurs" do
      before do
        allow(params_object).to receive(:permitted_params).and_return('hello')
      end

      it "returns the permitted_params" do
        expect(params_object.fetch).to eq 'hello'
      end
    end
  end
end
